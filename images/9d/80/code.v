module top_module(
   
   clk, in
   );input clk;
   input [9:0] in;

   reg a [9:0];
   integer ai;
   always @* begin
      for (ai=0;ai<10;ai=ai+1) begin
	 a[ai]=in[ai];
      end
   end

   reg [1:0] b [9:0];
   integer   j;

   generate
      genvar i;
      for (i=0; i<2; i=i+1) begin
	 always @(posedge clk) begin
	    for (j=0; j<10; j=j+1) begin
	       if (a[j])
		 b[i][j] <= 1'b0;
	       else
		 b[i][j] <= 1'b1;
	    end
	 end
      end
   endgenerate
endmodule