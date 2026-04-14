module top_module(dout, in0, in1, in2, sel0, sel1, sel2) ;parameter SIZE = 1;

output 	[SIZE-1:0] 	dout;
input	[SIZE-1:0]	in0;
input	[SIZE-1:0]	in1;
input	[SIZE-1:0]	in2;
input			sel0;
input			sel1;
input			sel2;

reg	[SIZE-1:0]	dout ;

// priority encoding takes care of mutex'ing selects.
always @ (sel0 or sel1 or sel2 or in0 or in1 or in2)
    case ({sel2,sel1,sel0}) 
        3'b001 : dout = in0 ;
        3'b010 : dout = in1 ;
        3'b100 : dout = in2 ;
        default : dout = {SIZE{1'bx}};
    endcase
endmodule