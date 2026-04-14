module N8080_RAM16X8D_regs(
      input [2:0]A,       	
      input [7:0]D,        
      input [2:0]DPRA, 		
      input WCLK,   			
      input WE,        		
      output [7:0]DPO,     
      output [7:0]SPO     
   );
	reg [7:0]data[4:0];
	assign DPO = data[DPRA];
	assign SPO = data[A];
	always @(posedge WCLK)
		if(WE) data[A] <= D;		
endmodule