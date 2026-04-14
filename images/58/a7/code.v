module top_module(d,q,clk,reset);input d,clk,reset;
  output q;
  reg q;

  always @(posedge clk or posedge reset)
	if(reset)
		q<=1'b0;
	else
		q<=d;endmodule