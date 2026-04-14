module top_module(
	 input  RegDst,           
	 input  [4:0] Rt,         
	 input  [4:0] Rd,         
	 output  [4:0] RegAddr    
    );assign RegAddr = RegDst ? Rd : Rt;endmodule