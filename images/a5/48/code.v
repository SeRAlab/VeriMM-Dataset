module top_module(clk, rst, clear, hold, in, out);parameter N = 1;
   
   input       clk;
   input       rst;
   input       clear;
   input       hold;   
   input wire [N-1:0]      in;
   output reg [N-1:0]      out;
   
	always @(posedge clk, negedge rst) begin
	   if (!rst) begin
	      out <= {N{1'b0}};
	   end
	   else if (clear) begin
	     out <= {N{1'b0}};
	   end
	   else if (hold) begin
	     out <= out;
	   end
	   else begin
	     out <= in;
	   end
	end
endmodule