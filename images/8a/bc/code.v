module top_module(
input   wire [31:0] col_in    ,
output  wire [ 7:0] byte_out
);function [7:0] xt2;
    input [7:0] a;
    xt2 = (a << 1) ^ (a[7] ? 8'h1b : 8'b0) ;
endfunction



function [7:0] xtN;
    input[7:0] a;
    input[3:0] b;
    xtN = (b[0] ?             a   : 0) ^
          (b[1] ? xt2(        a)  : 0) ^
          (b[2] ? xt2(xt2(    a)) : 0) ^
          (b[3] ? xt2(xt2(xt2(a))): 0) ;
endfunction

wire [7:0] b3 = col_in[ 7: 0];
wire [7:0] b2 = col_in[15: 8];
wire [7:0] b1 = col_in[23:16];
wire [7:0] b0 = col_in[31:24];

assign byte_out = xtN(b0,4'he) ^ xtN(b1,4'hb) ^ xtN(b2,4'hd) ^ xtN(b3,4'h9);endmodule