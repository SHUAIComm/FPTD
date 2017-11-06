mode = 1;
enable_f = 0;
sel_f = 0;
s1 = 0;
s2 = 0;
s3 = 0;

for i=1:10
    data_in = randi([0 127],1,200);
    [tout, bit_error, dc] = asic_data_mex(mode, enable_f, sel_f, s1, s2, s3, data_in);
end