module top_module(RegDst,Rd,Rt,writereg);input [1:0] RegDst;
input [4:0] Rd;
input [4:0] Rt;
output [4:0] writereg;

assign writereg = (RegDst == 2'b00) ? Rd :
                  (RegDst == 2'b01) ? Rt :
                  (RegDst == 2'b10) ? 5'b11111 :
                  5'b11010;

endmodule