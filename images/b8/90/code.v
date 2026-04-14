module top_module(A, Y);parameter WIDTH  = 0;
   parameter LUT    = 0;
   input [WIDTH-1:0] A;
   output            Y;
   generate
      if (WIDTH == 1) begin
	   assign Y = ~A[0]; 
      end else
      if (WIDTH == 2) begin
           twentynm_lcell_comb #(.lut_mask({16{LUT}}), .shared_arith("off"), .extended_lut("off"))
           _TECHMAP_REPLACE_ (.combout(Y), .dataa(A[0]), .datab(A[1]), .datac(1'b1),.datad(1'b1), .datae(1'b1), .dataf(1'b1), .datag(1'b1));
      end  else
	   wire _TECHMAP_FAIL_ = 1;
   endgenerate
endmodule