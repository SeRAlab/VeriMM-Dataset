module top_module(A, Y);parameter WIDTH  = 0;
   parameter LUT    = 0;
   (* force_downto *)
   input [WIDTH-1:0] A;
   output            Y;
   generate
      if (WIDTH == 1) begin
	   assign Y = ~A[0]; 
      end else
      if (WIDTH == 2) begin
           fiftyfivenm_lcell_comb #(.lut_mask({4{LUT}}), .sum_lutc_input("datac")) _TECHMAP_REPLACE_ (.combout(Y), .dataa(A[0]), .datab(A[1]), .datac(1'b1),.datad(1'b1));
      end else
      if(WIDTH == 3) begin
	      fiftyfivenm_lcell_comb #(.lut_mask({2{LUT}}), .sum_lutc_input("datac")) _TECHMAP_REPLACE_ (.combout(Y), .dataa(A[0]), .datab(A[1]), .datac(A[2]),.datad(1'b1));
      end else
      if(WIDTH == 4) begin
         fiftyfivenm_lcell_comb #(.lut_mask(LUT), .sum_lutc_input("datac")) _TECHMAP_REPLACE_ (.combout(Y), .dataa(A[0]), .datab(A[1]), .datac(A[2]),.datad(A[3]));
      end else
	   wire _TECHMAP_FAIL_ = 1;
   endgenerate
endmodule