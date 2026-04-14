module top_module(input [3:0]A0, A1, A2, A3 , input [1:0]M_select, output [3:0]M_out);assign M_out = M_select[1] ? 
			  ( M_select[0] ? A3 : A2 ) :
			  (M_select[0] ? A1 : A0 );
endmodule