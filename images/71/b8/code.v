module top_module(
	input rst_n,               
	input clk,                 
	input[11:0] top,           
	input[11:0] left,          
	input[11:0] width,         
	input[11:0] height,        
	input[11:0] x,             
	input[11:0] y,             
	input[7:0] i_alpha,        
	output reg[7:0] o_alpha,   
	output rdreq               
);reg rdreq_d0;

assign rdreq = (y > top) && (y <= top + height) && (x > left) && (x <= left + width);
always@(posedge clk)
begin
	rdreq_d0 <= rdreq;
end

always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		o_alpha <= 8'd0;
	else if(rdreq_d0)
		o_alpha <= i_alpha;
	else
		o_alpha <= 8'd0;
end
endmodule