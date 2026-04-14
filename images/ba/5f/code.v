module top_module(
	output [2:0] out             ,  
	input enable          ,  
	input clk             ,  
	input reset,            
	input [2:0] seed
);reg [2:0] out_reg;
wire linear_feedback;

assign linear_feedback = !(out[2] ^ out[0] ^ seed[2] ^ seed[1] ^ seed[0]);

always @(posedge clk)
if (reset) begin 
  out_reg = 3'b0 ;
end else if (enable) begin
  out_reg = {out[2] ^ seed[1], out[1] ^ seed[0], out[0], linear_feedback};
end

assign out = out_reg;

endmodule