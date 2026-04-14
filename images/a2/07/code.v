module top_module(
	add, opa, opb, 
	sum, co
	);input		add;
input	[26:0]	opa, opb;
output	[26:0]	sum;
output		co;












reg [26:0] rewrite_sum;
reg rewrite_co;

always @(*) begin
  rewrite_sum = sum;
end

always @(*) begin
  rewrite_co = co;
end







wire [27:0] rewrite_co_sum;
assign      rewrite_co_sum = add ? (opa + opb) : (opa - opb);
assign      co             = rewrite_co_sum[27];
assign      sum            = rewrite_co_sum[26:0];


endmodule