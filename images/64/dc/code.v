module top_module(out,in0,sel0,in1,sel1,in2,sel2,in3,sel3,in4,sel4) ;output [29:0] out ;
    input  [29:0] in0,in1,in2,in3,in4 ;
    input sel0,sel1,sel2,sel3,sel4 ;

    reg [29:0] out ;

	wire [4:0] select = {sel0,sel1,sel2,sel3,sel4} ;
	always @ ((select) or (in0) or (in1) or (in2) or (in3) or (in4))
		case (select) 
			5'b10000:	out = in0;
			5'b01000:	out = in1;
			5'b00100:	out = in2 ;
			5'b00010:	out = in3 ;
			5'b00001:	out = in4 ;
			
			default: out = 65'hx;
			
		endcase
endmodule