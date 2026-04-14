module top_module(
  output [31:0] out,
  input [31:0] in_1, in_2,
  input select
);reg [31:0] out_select;
  assign out = out_select;
  always@(*) begin
	casex(select) 
		1'b0: out_select = in_1;
		1'b1: out_select = in_2;
		1'bx: out_select = 32'bx;
	endcase
  end	
 
endmodule