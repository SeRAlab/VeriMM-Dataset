module top_module(input1, input2, out);input [15:0] input1, input2;
    output [30:0] out;
    
    wire [30:0] out;
    wire [29:0] mul,cmpmul;
    wire [14:0] a,b;
    wire sign;
    
    assign a = (input1[15]==0) ? input1[14:0] : ~input1[14:0] + 1'b1;
    assign b = (input2[15]==0) ? input2[14:0] : ~input2[14:0] + 1'b1;
    assign sign = (input1 == 16'h0000 || input2 == 16'h0000) ? 1'b0 : input1[15] ^ input2[15];
    
    assign mul = a * b;
    assign cmpmul = ~mul + 1'b1;
    assign out = (sign==0) ? {1'b0,mul} : {1'b1,cmpmul};endmodule