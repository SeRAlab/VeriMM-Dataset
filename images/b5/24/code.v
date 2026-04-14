module top_module(
   
   out,
   
   clk, noswap, nibble, in
   );input clk;

   input noswap;
   input nibble;

   input  [31:0] in;
   output [31:0] out;

   function [7:0] EndianSwap;
      input Nibble;
      input [7:0] Data;
      begin
         EndianSwap = (Nibble ? { Data[0], Data[1], Data[2], Data[3],
				  Data[4], Data[5], Data[6], Data[7] }
                       : { 4'h0, Data[0], Data[1], Data[2], Data[3] });
      end
   endfunction

   assign out[31:24] = (noswap ? in[31:24]
			: EndianSwap(nibble, in[31:24]));
   assign out[23:16] = (noswap ? in[23:16]
			: EndianSwap(nibble, in[23:16]));
   assign out[15:8]  = (noswap ? in[15:8]
			: EndianSwap(nibble, in[15:8]));
   assign out[7:0]   = (noswap ? in[7:0]
			: EndianSwap(nibble, in[7:0]));
endmodule