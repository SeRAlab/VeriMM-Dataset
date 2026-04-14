module top_module( clk, io_cs, io_rd, io_wr, addr, 
						  D_in_IO, D_out_IO, int_ack, intr );input         clk, io_cs, io_rd, io_wr, int_ack;
	input  [31:0] D_in_IO;
	input  [31:0] addr;
	
	
	output 	     intr;
	output [31:0] D_out_IO;
	
	reg     [7:0] IOMem [4095:0];
	reg           intr;
 
	
	always @ ( posedge clk )
	
		
		if( (io_cs && io_wr) == 1'b1 )
			{ IOMem[addr], IOMem[addr + 1], IOMem[addr + 2], IOMem[addr + 3] } <= D_in_IO;
		else
			{ IOMem[addr], IOMem[addr + 1], IOMem[addr + 2], IOMem[addr + 3] } <= 
			{ IOMem[addr], IOMem[addr + 1], IOMem[addr + 2], IOMem[addr + 3] };
		
	
	
	assign D_out_IO = ( (io_cs && io_rd) == 1'b1 ) ? { IOMem[addr]    ,
	                                                   IOMem[addr + 1],
												           	      IOMem[addr + 2],
													               IOMem[addr + 3]} : 32'bZZZZ_ZZZZ;
	
	
	
	
	
													
endmodule