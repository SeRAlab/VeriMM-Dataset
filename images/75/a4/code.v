module top_module(
		input  wire [7:0]  avs_s0_address,     
		input  wire        avs_s0_read,        
		output wire [31:0] avs_s0_readdata,    
		input  wire        avs_s0_write,       
		input  wire [31:0] avs_s0_writedata,   
		output wire        avs_s0_waitrequest, 
		input  wire        clock_clk,          
		input  wire        reset_reset,        
		output wire        ins_irq0_irq,       
		output wire [7:0]  avm_m0_address,     
		output wire        avm_m0_read,        
		input  wire        avm_m0_waitrequest, 
		input  wire [31:0] avm_m0_readdata,    
		output wire        avm_m0_write,       
		output wire [31:0] avm_m0_writedata    
	);assign ins_irq0_irq = 1'b0; 
	
	assign avm_m0_address = 8'b00000000;
	assign avm_m0_read = 1'b0;
	assign avm_m0_write = 1'b0;
	assign avm_m0_writedata = 32'b00000000000000000000000000000000;
	
	


endmodule