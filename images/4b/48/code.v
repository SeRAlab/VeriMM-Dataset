module top_module(
   input  wire [1:0] clkvec,
   output wire [1:0] count
   );genvar igen;
   generate
      for (igen=0; igen<2; igen=igen+1) begin : code_gen
	 wire clk_tmp = clkvec[igen];
	 reg  tmp_count = 1'b0;
	 always @ (posedge clk_tmp) begin
	    tmp_count <= tmp_count + 1;
	 end
	 assign count[igen] = tmp_count;
      end
   endgenerate
endmodule