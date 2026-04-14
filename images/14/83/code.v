module sha256_transform(input [31:0] data_in, output [31:0] data_out);  
    parameter CONSTANT = 32'h5A827999;  
    assign data_out = data_in + CONSTANT;  
endmodule