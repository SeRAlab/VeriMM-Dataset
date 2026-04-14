module top_module( SP, IorD, newSP);input [15:0] SP;
    input IorD;
    output [15:0] newSP;
	 wire [13:0] eSP, eNewSP;
	 
	 assign eSP = {SP[15:12] , SP[9:0]};
	 assign eNewSP = eSP + (IorD ?  1  :  14'h3fff );
	 assign newSP = {eNewSP[13:10] , 2'b00 , eNewSP[9:0]};
	 
endmodule