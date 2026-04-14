module top_module(


    a_din,
    a_dout,
    a_dout_en,


    b_din,
    b_dout,
    b_dout_en,


    io_din,
    io_dout,
    io_dout_en,


    sel
);parameter          WIDTH = 8;
   


output [WIDTH-1:0] a_din;
input  [WIDTH-1:0] a_dout;
input  [WIDTH-1:0] a_dout_en;



output [WIDTH-1:0] b_din;
input  [WIDTH-1:0] b_dout;
input  [WIDTH-1:0] b_dout_en;



input  [WIDTH-1:0] io_din;
output [WIDTH-1:0] io_dout;
output [WIDTH-1:0] io_dout_en;



input  [WIDTH-1:0] sel;






function [WIDTH-1:0] mux (
   input [WIDTH-1:0] A,
   input [WIDTH-1:0] B,
   input [WIDTH-1:0] SEL
);
   integer i;   
   begin
      mux = {WIDTH{1'b0}};
      for (i = 0; i < WIDTH; i = i + 1)
	mux[i] = sel[i] ? B[i] : A[i];
   end
endfunction


assign a_din      = mux(       io_din, {WIDTH{1'b0}}, sel);
assign b_din      = mux({WIDTH{1'b0}},        io_din, sel);
assign io_dout    = mux(       a_dout,        b_dout, sel);
assign io_dout_en = mux(    a_dout_en,     b_dout_en, sel);

	   
endmodule