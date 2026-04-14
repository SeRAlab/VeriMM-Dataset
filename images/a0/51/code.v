module top_module(
  clk,
  rst_n,
  req,
  grant
  );parameter REQ_NUM = 4;
  
  input  clk;
  input  rst_n;
  input  [REQ_NUM-1:0] req;
  output reg [REQ_NUM-1:0] grant;
  
  generate
    genvar i;
	  
	  always @ (posedge clk, negedge rst_n) begin
      if (~rst_n)
	      grant[0] <= 1'b0;
	    else
	      grant[0] <= req[0]; 
    end
	  
	  for (i = 1; i < REQ_NUM; i=i+1) begin: uGrant
      always @ (posedge clk, negedge rst_n) begin
        if (~rst_n)
	        grant[i] <= 1'b0;
	      else
	        grant[i] <= req[i] & ~|req[i-1:0]; 
      end
	  end 
  endgenerate
  
endmodule