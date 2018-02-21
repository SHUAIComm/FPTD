clear
mode = 0;
enable_f = 0;
sel_f = 0;
s1 = 0;
s2 = 0;
s3 = 1;
frame_length = 40;
Eb_N0_start = 0;
Eb_N0_step = 1;
Eb_N0_stop = 4;
N = 4;
M = 5;
NDS = 0.7;
sim_index = 1;

% for i=1:10
%     [data_in, data_out] = Function_6cycles(40, 0, 1, 4, 4, 5, 0.7, 1, i);
%     for clock_index = 1:length(data_in)
%         i_data_in = data_in(clock_index,:);
%         %[tout, bit_error, dc] = asic_data_mex(mode, enable_f, sel_f, s1, s2, s3, i_data_in);
%         %if(mode)
%          %   display([i bit_error]);
%         %else
%             display(i_data_in);
%         %end
%     end
% end


% Re-randomize seed of Random number generator
rand('seed',sum(clock)*(1000+sim_index*100));
% rng('default');
% rng(0);
% Setup all variables
% Choose parameters for the turbo decoder
global approx_maxstar;
approx_maxstar = 1;

scaling = 0.75;
tc = 1; % Two's complement
for Eb_N0=Eb_N0_start:Eb_N0_step:Eb_N0_stop
    
    % Save all output data into txt files to compare the results
    file_upper_output_odd = ['Data_FPGA_6cycles/upper_output_odd_' num2str(frame_length) '_' num2str(N) 'N' num2str(M) 'M_' sprintf('%1.2f',Eb_N0) 'dB.txt'];
    file_upper_output_even = ['Data_FPGA_6cycles/upper_output_even_' num2str(frame_length) '_' num2str(N) 'N' num2str(M) 'M_' sprintf('%1.2f',Eb_N0) 'dB.txt'];
    file_lower_output_odd = ['Data_FPGA_6cycles/lower_output_odd_' num2str(frame_length) '_' num2str(N) 'N' num2str(M) 'M_' sprintf('%1.2f',Eb_N0) 'dB.txt'];
    file_lower_output_even = ['Data_FPGA_6cycles/lower_output_even_' num2str(frame_length) '_' num2str(N) 'N' num2str(M) 'M_' sprintf('%1.2f',Eb_N0) 'dB.txt'];
    file_total_output = ['Data_FPGA_6cycles/total_output_' num2str(frame_length) '_' num2str(N) 'N' num2str(M) 'M_' sprintf('%1.2f',Eb_N0) 'dB.txt'];
    file_tout = ['Data_FPGA_6cycles/tout_' num2str(frame_length) '_' num2str(N) 'N' num2str(M) 'M_' sprintf('%1.2f',Eb_N0) 'dB.txt'];
    file_total_input = ['Data_FPGA_6cycles/total_input_' num2str(frame_length) '_' num2str(N) 'N' num2str(M) 'M_' sprintf('%1.2f',Eb_N0) 'dB.txt'];
    
    % Initalise the interleaver
    interleaver = get_LTE_interleaver(frame_length);
    
    % Calculate the number of bits per symbol
    bits_per_symbol = frame_length/(3*frame_length+12);
    
    % Convert from Eb/N0 (in dB) to SNR (in dB)
    SNR = Eb_N0 + 10*log10(bits_per_symbol);
    
    % Convert from SNR (in dB) to noise power spectral density
    N0 = 1/(10^(SNR/10));
    
    
    % Continue the simulation until enough frame errors or bits have been simulated
        
        % Initially only simulate the transmission of the systematic bits -
        % if these are recovered without error then there is no need to
        % simulate the transmission of the parity bits
        
        % Turbo Encoder
        a = round(rand(1,frame_length));    % Generate a random frame of bits
        b = a(interleaver);                 % Interleave the random frame of bits
        [c,e] = convolutional_encoder(a);   % Generate the parity bits
        [d,f] = convolutional_encoder(b);   % Generate the parity bits
        
        % Channel Noise
        a_c = tx_rx_AWGN(a,N0);
        c_c = tx_rx_AWGN(c,N0);
        d_c = tx_rx_AWGN(d,N0);
        e_c = tx_rx_AWGN(e,N0);
        f_c = tx_rx_AWGN(f,N0);
        
        % Round all LLRs
        a_c = round(a_c*NDS*N0);
        c_c = round(c_c*NDS*N0);
        d_c = round(d_c*NDS*N0);
        e_c = round(e_c*NDS*N0);
        f_c = round(f_c*NDS*N0);
        a_c = sat_FX(tc,N,a_c);
        c_c = sat_FX(tc,N,c_c);
        d_c = sat_FX(tc,N,d_c);
        e_c = sat_FX(tc,N,e_c);
        f_c = sat_FX(tc,N,f_c);
        b_c = a_c(interleaver); % Interleave the systematic LLRs
        
        % Turbo Decoder (Initialization)
        % Initialise a priori and extrinsic LLRs to zero
        a_e = zeros(size(a_c));
        a_a = zeros(size(a_c));
        y_e = zeros(size(c_c));
        z_e = zeros(size(c_c));
        
        % Inialise extrinsic alphas and betas
        upper_extrinsic_betas=zeros(8,length(c_c)+1);
        upper_extrinsic_betas(2:end,end)=sat_FX(tc,M,-Inf); % We know that these are not the final state
        upper_extrinsic_alphas=zeros(8,length(c_c)+1);
        upper_extrinsic_alphas(2:end,1)=sat_FX(tc,M,-Inf); % We know that these are not the first state
        
        lower_extrinsic_betas=zeros(8,length(c_c)+1);
        lower_extrinsic_betas(2:end,end)=sat_FX(tc,M,-Inf); % We know that these are not the final state
        lower_extrinsic_alphas=zeros(8,length(c_c)+1);
        lower_extrinsic_alphas(2:end,1)=sat_FX(tc,M,-Inf); % We know that these are not the first state
        
        
        % Initialize previous LLRs
        upper_apriori_alphas = upper_extrinsic_alphas;
        upper_apriori_betas = upper_extrinsic_betas;
        lower_apriori_alphas = lower_extrinsic_alphas;
        lower_apriori_betas = lower_extrinsic_betas;
        
        %         but1 = zeros(256,length(e_c));
        %         bua2 = zeros(256,length(c_c));
        %         bua3 = zeros(256,length([a_c 0 0 0]));
        %         blt1 = zeros(256,length(f_c));
        %         bla2 = zeros(256,length(d_c));
        %         bla3 = zeros(256,length([b_c 0 0 0]));
        %         b1 =zeros(256,length([a_c  0 0 0]));
        
        bua2 = offset_data(N,c_c);
        bua3 = offset_data(N,[a_c 0 0 0]);
        bla2 = offset_data(N,d_c);
        bla3 = offset_data(N,[b_c 0 0 0]);
         
        upper_input_odd_unit = zeros(22*7,18);
        upper_output_odd_unit = zeros(22*7,16);
        lower_input_even_unit = zeros(21*7,18);
        lower_output_even_unit = zeros(21*7,16);     
        upper_input_even_unit = zeros(21*7,18);
        upper_output_even_unit = zeros(21*7,16);
        lower_input_odd_unit = zeros(22*7,18);
        lower_output_odd_unit = zeros(22*7,16);
        
        for iteration_index = 1:1:10
            % Update a priori alphas and betas
            upper_apriori_alphas = upper_extrinsic_alphas;
            upper_apriori_betas = upper_extrinsic_betas;
            lower_apriori_alphas = lower_extrinsic_alphas;
            lower_apriori_betas = lower_extrinsic_betas;
            
            % Interleave the extrinsic LLRs
            b_a = a_e(interleaver);
            
            % Obtain the uncoded a priori input for upper decoder
            y_a = [sat_FX(tc,M,floor(a_a*scaling) + a_c), e_c];
            
            % Obtain the uncoded a priori input for lower decoder
            z_a = [sat_FX(tc,M,floor(b_a*scaling) + b_c), f_c]; 

            index_upper_odd = 1;
            index_lower_even = 1;
            bua1 = [a_a 0 0 0];
            bla1 = [b_a 0 0 0];            
            % Get b1_ideal
            b1_ideal = [a 0 0 0];
            % Operate the upper block decoders having odd indices and the lower block decoders having even indices in parallel
            for bit_index = 1:length(y_a)
                if mod(bit_index,2)==1
                    [y_e(bit_index), upper_extrinsic_betas(:,bit_index), upper_extrinsic_alphas(:,bit_index+1)] = block_decoder_FX_NoSat(y_a(bit_index), upper_apriori_alphas(:,bit_index), upper_apriori_betas(:,bit_index+1),c_c(bit_index),tc,M);
                    upper_input_odd_unit(index_upper_odd + 5,:) = [bua1(bit_index) bua2(bit_index) bua3(bit_index) upper_apriori_alphas(2:end,bit_index).' upper_apriori_betas(2:end,bit_index+1).' b1_ideal(bit_index)];
                    upper_output_odd_unit(index_upper_odd + 5,:) = [upper_extrinsic_alphas(2:end,bit_index+1).' upper_extrinsic_betas(2:end,bit_index).' y_e(bit_index) 0];
                    index_upper_odd = index_upper_odd + 7; 
                else
                    [z_e(bit_index), lower_extrinsic_betas(:,bit_index), lower_extrinsic_alphas(:,bit_index+1)] = block_decoder_FX_NoSat(z_a(bit_index), lower_apriori_alphas(:,bit_index), lower_apriori_betas(:,bit_index+1),d_c(bit_index),tc,M);
                    lower_input_even_unit(index_lower_even + 5,:) = [bla1(bit_index) bla2(bit_index) bla3(bit_index) lower_apriori_alphas(2:end,bit_index).' lower_apriori_betas(2:end,bit_index+1).' b1_ideal(bit_index)];
                    lower_output_even_unit(index_lower_even + 5,:) = [lower_extrinsic_alphas(2:end,bit_index+1).' lower_extrinsic_betas(2:end,bit_index).' z_e(bit_index) 0];
                    index_lower_even = index_lower_even + 7;
                end
            end

            % Remove the LLRs corresponding to the termination bits
            a_e = y_e(1:length(a));
            
            % Remove the LLRs corresponding to the termination bits
            b_e = z_e(1:length(b));
            
            % Deinterleave the extrinsic LLRs
            a_a(interleaver) = b_e;
            
            % Update a priori alphas and betas
            upper_apriori_alphas = upper_extrinsic_alphas;
            upper_apriori_betas = upper_extrinsic_betas;
            lower_apriori_alphas = lower_extrinsic_alphas;
            lower_apriori_betas = lower_extrinsic_betas;
            
            % Interleave the extrinsic LLRs
            b_a = a_e(interleaver);
            
            % Obtain the uncoded a priori input for upper decoder
            y_a = [sat_FX(tc,M,floor(a_a*scaling) + a_c), e_c];
            
            % Obtain the uncoded a priori input for lower decoder
            z_a = [sat_FX(tc,M,floor(b_a*scaling) + b_c), f_c];
         
            % Set index for result matrixs
            index_upper_even = 1;
            index_lower_odd = 1;
%             upper_input_even_unit = zeros(round(length(y_a)/2)-1,19);
%             upper_output_even_unit = zeros(round(length(y_a)/2)-1,17);
%             lower_input_odd_unit = zeros(round(length(y_a)/2),19);
%             lower_output_odd_unit = zeros(round(length(y_a)/2),17);

               
            % Obtain bla1 and bua1 from substration of z_a(y-a) and bla3(lua3)
            bua1(iteration_index,:) = [a_a 0 0 0];
            bla1(iteration_index,:) = [b_a 0 0 0];
            
           
            % Operate the upper block decoders having even indices and the lower block decoders having odd indices in parallel
            for bit_index = 1:length(y_a)
                if mod(bit_index,2)==0
                    [y_e(bit_index), upper_extrinsic_betas(:,bit_index), upper_extrinsic_alphas(:,bit_index+1)] = block_decoder_FX_NoSat(y_a(bit_index), upper_apriori_alphas(:,bit_index), upper_apriori_betas(:,bit_index+1),c_c(bit_index),tc,M);
                    upper_input_even_unit(index_upper_even + 5,:) = [bua1(bit_index) bua2(bit_index) bua3(bit_index) upper_apriori_alphas(2:end,bit_index).' upper_apriori_betas(2:end,bit_index+1).' b1_ideal(bit_index)];
                    upper_output_even_unit(index_upper_even + 5,:) = [upper_extrinsic_alphas(2:end,bit_index+1).' upper_extrinsic_betas(2:end,bit_index).' y_e(bit_index) 0];
                    index_upper_even = index_upper_even + 7;
                else
                    [z_e(bit_index), lower_extrinsic_betas(:,bit_index), lower_extrinsic_alphas(:,bit_index+1)] = block_decoder_FX_NoSat(z_a(bit_index), lower_apriori_alphas(:,bit_index), lower_apriori_betas(:,bit_index+1),d_c(bit_index),tc,M);
                    lower_input_odd_unit(index_lower_odd + 5,:) = [bla1(bit_index) bla2(bit_index) bla3(bit_index) lower_apriori_alphas(2:end,bit_index).' lower_apriori_betas(2:end,bit_index+1).' b1_ideal(bit_index)];
                    lower_output_odd_unit(index_lower_odd + 5,:) = [lower_extrinsic_alphas(2:end,bit_index+1).' lower_extrinsic_betas(2:end,bit_index).' z_e(bit_index) 0];
                    index_lower_odd = index_lower_odd + 7;
                end
            end
            % Fill 200 bits before the message bits
%             upper_input_odd_changed = input_arrange(upper_input_odd_unit);
%             upper_input_even_changed = input_arrange(upper_input_even_unit);
%             lower_input_odd_changed = input_arrange(lower_input_odd_unit);
%             lower_input_even_changed = input_arrange(lower_input_even_unit);
%             upper_output_odd_changed = output_arrange(upper_output_odd_unit);
%             upper_output_even_changed = output_arrange(upper_output_even_unit);
%             lower_output_odd_changed = output_arrange(lower_output_odd_unit);
%             lower_output_even_changed = output_arrange(lower_output_even_unit);
            
%           Fill 200 bits after the message bits            
            upper_input_odd_changed = input_alter(upper_input_odd_unit);
            upper_input_even_changed = input_alter(upper_input_even_unit);
            lower_input_odd_changed = input_alter(lower_input_odd_unit);
            lower_input_even_changed = input_alter(lower_input_even_unit);
            upper_output_odd_changed = output_arrange(upper_output_odd_unit);
            upper_output_even_changed = output_arrange(upper_output_even_unit);
            lower_output_odd_changed = output_arrange(lower_output_odd_unit);
            lower_output_even_changed = output_arrange(lower_output_even_unit);
            
%           Input all binary bits            
%             upper_input_odd_changed = input_binary(upper_input_odd_unit);
%             upper_input_even_changed = input_binary(upper_input_even_unit);
%             lower_input_odd_changed = input_binary(lower_input_odd_unit);
%             lower_input_even_changed = input_binary(lower_input_even_unit);
%             upper_output_odd_changed = output_arrange(upper_output_odd_unit);
%             upper_output_even_changed = output_arrange(upper_output_even_unit);
%             lower_output_odd_changed = output_arrange(lower_output_odd_unit);
%             lower_output_even_changed = output_arrange(lower_output_even_unit);
            
            % Combine all Odd and Even clock cycles.
            % Order by Upper_Odd,Lower_Even, Upper_Even, Lower_Odd
            total_input = [upper_input_odd_changed; lower_input_even_changed; upper_input_even_changed; lower_input_odd_changed];
            total_output = [upper_output_odd_changed; lower_output_even_changed; upper_output_even_changed; lower_output_odd_changed];
            input_size = size(total_input);
            total_input = fliplr(total_input);
            total_output = fliplr(total_output);

%             Input data into the FPGA
            for clock_index = 1:input_size(1)
                data_in = total_input(clock_index,:);
                [tout, bit_error, dc] = asic_data_mex(mode, enable_f, sel_f, s1, s2, s3, data_in);
                tout = bitshift(tout,-1); % remove the first output row which is not valid from ASIC
                tout_matlab = total_output(clock_index,:);
                if(mode)
                    display([i bit_error]);
                else
                    display(tout(5:79));
                    display(tout_matlab(5:79))
                    if ~isequal(tout(5:79), tout_matlab(5:79))
                        disp('Output result not match between ASIC and Matlab');
                    end
                    if Eb_N0 == 0.0 && iteration_index == 0 && clock_index == 1
                        dlmwrite(file_tout, tout, 'delimiter',' ');
                    else
                        dlmwrite(file_tout, tout, 'delimiter',' ','-append');
                    end
                end
            end
% %             Save output data into txt files
            if  Eb_N0 == 0.0 && iteration_index == 0
                dlmwrite(file_upper_output_odd, upper_output_odd_changed, 'delimiter',' ');
                dlmwrite(file_upper_output_even, upper_output_even_changed, 'delimiter',' ');
                dlmwrite(file_lower_output_odd, lower_output_odd_changed, 'delimiter',' ');
                dlmwrite(file_lower_output_even, lower_output_even_changed, 'delimiter',' ');
                dlmwrite(file_total_output, total_output, 'delimiter',' ');
                dlmwrite(file_total_input, total_input, 'delimiter',' ');
            else
                dlmwrite(file_upper_output_odd, upper_output_odd_changed, 'delimiter',' ','-append');
                dlmwrite(file_upper_output_even, upper_output_even_changed, 'delimiter',' ','-append');
                dlmwrite(file_lower_output_odd, lower_output_odd_changed, 'delimiter',' ','-append');
                dlmwrite(file_total_output, total_output, 'delimiter',' ','-append');
                dlmwrite(file_total_input, total_input, 'delimiter',' ','-append');
            end
            % Replace the first cycles data with the present one
              for index_memory = 1 : 7: length(upper_input_odd_unit)
                        % Upper_input_odd_unit update
                        upper_input_odd_unit (index_memory,:) = upper_input_odd_unit(index_memory + 1 ,:);
                        upper_input_odd_unit (index_memory + 1,:) = upper_input_odd_unit(index_memory + 3 ,:);
                        upper_input_odd_unit (index_memory + 2,:) = upper_input_odd_unit(index_memory + 3 ,:);
                        upper_input_odd_unit (index_memory + 3,:) = upper_input_odd_unit(index_memory + 5 ,:);
                        upper_input_odd_unit (index_memory + 4,:) = upper_input_odd_unit(index_memory + 5 ,:);
                        % Upper_output_odd_unit update
                        upper_output_odd_unit (index_memory,:) = upper_output_odd_unit(index_memory + 1 ,:);
                        upper_output_odd_unit (index_memory + 1,:) = upper_output_odd_unit(index_memory + 3 ,:);
                        upper_output_odd_unit (index_memory + 2,:) = upper_output_odd_unit(index_memory + 3 ,:);
                        upper_output_odd_unit (index_memory + 3,:) = upper_output_odd_unit(index_memory + 5 ,:);
                        upper_output_odd_unit (index_memory + 4,:) = upper_output_odd_unit(index_memory + 5 ,:);
                        % Lower_input_odd_unit update
                        lower_input_odd_unit (index_memory,:) = lower_input_odd_unit(index_memory + 1 ,:);
                        lower_input_odd_unit (index_memory + 1,:) = lower_input_odd_unit(index_memory + 3 ,:);
                        lower_input_odd_unit (index_memory + 2,:) = lower_input_odd_unit(index_memory + 3 ,:);
                        lower_input_odd_unit (index_memory + 3,:) = lower_input_odd_unit(index_memory + 5 ,:);
                        lower_input_odd_unit (index_memory + 4,:) = lower_input_odd_unit(index_memory + 5 ,:);
                        % Lower_output_odd_unit update
                        lower_output_odd_unit (index_memory,:) = lower_output_odd_unit(index_memory + 1 ,:);
                        lower_output_odd_unit (index_memory + 1,:) = lower_output_odd_unit(index_memory + 3 ,:);
                        lower_output_odd_unit (index_memory + 2,:) = lower_output_odd_unit(index_memory + 3 ,:);
                        lower_output_odd_unit (index_memory + 3,:) = lower_output_odd_unit(index_memory + 5 ,:);
                        lower_output_odd_unit (index_memory + 4,:) = lower_output_odd_unit(index_memory + 5 ,:);
              end
              
              for index_memory = 1 : 7: length(upper_input_even_unit)          
                        % Lower_input_even_unit update
                        lower_input_even_unit (index_memory,:) = lower_input_even_unit(index_memory + 1 ,:);
                        lower_input_even_unit (index_memory + 1,:) = lower_input_even_unit(index_memory + 3 ,:);
                        lower_input_even_unit (index_memory + 2,:) = lower_input_even_unit(index_memory + 3 ,:);
                        lower_input_even_unit (index_memory + 3,:) = lower_input_even_unit(index_memory + 5 ,:);
                        lower_input_even_unit (index_memory + 4,:) = lower_input_even_unit(index_memory + 5 ,:);
                        % Lower_output_even_unit update
                        lower_output_even_unit (index_memory,:) = lower_output_even_unit(index_memory + 1 ,:);
                        lower_output_even_unit (index_memory + 1,:) = lower_output_even_unit(index_memory + 3 ,:);
                        lower_output_even_unit (index_memory + 2,:) = lower_output_even_unit(index_memory + 3 ,:);
                        lower_output_even_unit (index_memory + 3,:) = lower_output_even_unit(index_memory + 5 ,:);
                        lower_output_even_unit (index_memory + 4,:) = lower_output_even_unit(index_memory + 5 ,:);
                        % Upper_input_even_unit update
                        upper_input_even_unit (index_memory,:) = upper_input_even_unit(index_memory + 1 ,:);
                        upper_input_even_unit (index_memory + 1,:) = upper_input_even_unit(index_memory + 3 ,:);
                        upper_input_even_unit (index_memory + 2,:) = upper_input_even_unit(index_memory + 3 ,:);
                        upper_input_even_unit (index_memory + 3,:) = upper_input_even_unit(index_memory + 5 ,:);
                        upper_input_even_unit (index_memory + 4,:) = upper_input_even_unit(index_memory + 5 ,:);
                        % Upper_output_even_unit update
                        upper_output_even_unit (index_memory,:) = upper_output_even_unit(index_memory + 1 ,:);
                        upper_output_even_unit (index_memory + 1,:) = upper_output_even_unit(index_memory + 3 ,:);
                        upper_output_even_unit (index_memory + 2,:) = upper_output_even_unit(index_memory + 3 ,:);
                        upper_output_even_unit (index_memory + 3,:) = upper_output_even_unit(index_memory + 5 ,:);
                        upper_output_even_unit (index_memory + 4,:) = upper_output_even_unit(index_memory + 5 ,:);
              end
        end
end






