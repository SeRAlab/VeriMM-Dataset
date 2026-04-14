module top_module(r, q, clk, n_rst);input  r, clk, n_rst;
   output [4:0] q;
   
   reg [4:0]        q;
   always @(posedge clk or negedge n_rst) begin
	  if (n_rst == 0)
        q <= 1;
      else if (r == 1 || q[4] == 1)
		q <= 1;
	  else 
		q <= q << 1;
	  
   end 
endmodule