module top_module(A, Y);parameter WIDTH  = 0;
   parameter LUT    = 0;
   (* force_downto *)
   input [WIDTH-1:0] A;
   output 	     Y;
   generate
      if (WIDTH == 1) begin
	   
         LUT4 #(.lut_function({4{LUT}})) _TECHMAP_REPLACE_
           (.dout(Y), .din0(A[0]), .din1(1'b0), .din2(1'b0), .din3(1'b0));
      end else
      if (WIDTH == 2) begin
              LUT4 #(.lut_function({4{LUT}})) _TECHMAP_REPLACE_
                (.dout(Y), .din0(A[0]), .din1(A[1]), .din2(1'b0), .din3(1'b0));
      end else
      if(WIDTH == 3) begin
	      LUT4 #(.lut_function({2{LUT}})) _TECHMAP_REPLACE_
                (.dout(Y), .din0(A[0]), .din1(A[1]), .din2(A[2]), .din3(1'b0));
      end else
      if(WIDTH == 4) begin
             LUT4 #(.lut_function(LUT)) _TECHMAP_REPLACE_
               (.dout(Y), .din0(A[0]), .din1(A[1]), .din2(A[2]), .din3(A[3]));
      end else
	   wire _TECHMAP_FAIL_ = 1;
   endgenerate
endmodule