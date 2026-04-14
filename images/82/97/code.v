module top_module(input [31:0] data_in, output [31:0] data_out);wire [31:0] mul_out;
    wire [31:0] sub_out;
    
    assign mul_out = data_in * 5;
    assign sub_out = mul_out - 7;
    
    assign data_out = sub_out;
endmodule