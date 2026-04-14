module top_module(
    input [31:0] ADDR_in,
    input we,
    
	
    input [31:0] T0_data_in,
    input [31:0] T1_data_in,
	
    output [3:2] ADDR_T0_out,
    output [3:2] ADDR_T1_out,
    
    output [31:0] READ_data_out,
	output T0_we,
	output T1_we
    );assign T0_we=((ADDR_in>=32'h00007f00 && ADDR_in<=32'h00007f0b)&&(we==1))?1:0;
	assign T1_we=((ADDR_in>=32'h00007f10 && ADDR_in<=32'h00007f1b)&&(we==1))?1:0;
	
	assign ADDR_T0_out=ADDR_in[3:2];
	assign ADDR_T1_out=ADDR_in[3:2];
	
	assign READ_data_out=(ADDR_in>=32'h00007f00 && ADDR_in<=32'h00007f0b)?T0_data_in:
						 (ADDR_in>=32'h00007f10 && ADDR_in<=32'h00007f1b)?T1_data_in:
						 0;

endmodule