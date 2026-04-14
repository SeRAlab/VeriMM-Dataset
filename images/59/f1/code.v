module top_module(
    input [31:0] in,
    output [31:0] out
);wire [7:0] byte1 = in[31:24];
    wire [7:0] byte2 = in[23:16];
    wire [7:0] byte3 = in[15:8];
    wire [7:0] byte4 = in[7:0];
    
    wire [15:0] temp = {byte3, byte2};
    
    assign out = {byte1, temp[15:8], temp[7:0], byte4};
    
endmodule