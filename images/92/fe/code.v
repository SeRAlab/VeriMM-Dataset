module top_module(input [25:0]in,output reg[31:0] out);always@(in)
  out=(in[25])?{6'b111111,in}:{6'b000000,in};
endmodule