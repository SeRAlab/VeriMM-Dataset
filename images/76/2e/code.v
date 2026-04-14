module top_module(
	y,cb,cr,
	red,green,blue,
	clk
);input clk;

input [7:0] y,cb,cr;
output reg [7:0] red,green,blue;


reg signed [8:0] adj_y,adj_cb,adj_cr;
always @(posedge clk) begin
	adj_y <= y;
	adj_cr <= cr - 8'd128;
	adj_cb <= cb - 8'd128;
end





wire signed [8:0] const0 = 9'd128; 
wire signed [8:0] const1 = 9'd179; 
wire signed [8:0] const2 = - 9'd91; 
wire signed [8:0] const3 = - 9'd44;	
wire signed [8:0] const4 = 9'd227; 






reg signed [17:0] product_a, product_b, product_c, 
	product_d, product_e;
always @(posedge clk) begin
	product_a <= const0 * adj_y;
	product_b <= const1 * adj_cr;
	product_c <= const2 * adj_cr;
	product_d <= const3 * adj_cb;
	product_e <= const4 * adj_cb;
end


reg signed [17:0] sum_red, sum_green, sum_blue;
always @(posedge clk) begin
	sum_red <= product_a + product_b;
	sum_green <= product_a + product_c + product_d;
	sum_blue <= product_a + product_e;
end


always @(posedge clk) begin
	red <= sum_red[17] ? 8'h0 : 
			(sum_red[15] | sum_red[16]) ? 8'hff :
			sum_red [14:7];
	green <= sum_green[17] ? 8'h0 : 
			(sum_green[15] | sum_green[16]) ? 8'hff :
			sum_green [14:7];
	blue <= sum_blue[17] ? 8'h0 : 
			(sum_blue[15] | sum_blue[16]) ? 8'hff :
			sum_blue [14:7];
end

endmodule