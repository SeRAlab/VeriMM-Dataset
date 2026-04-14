module top_module(
      output [7:0]DPO,     
      output [7:0]SPO,     
      input [3:0]A,       	
      input [7:0]D,        
      input [3:0]DPRA, 		
      input WCLK,   			
      input WE        		
   );reg [7:0]data[15:0];
	assign DPO = data[DPRA];
	assign SPO = data[A];
	
	always @(posedge WCLK)
		if(WE) data[A] <= D;		

endmodule