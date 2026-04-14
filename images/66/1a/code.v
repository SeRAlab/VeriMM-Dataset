module top_module(
		input  wire [7:0]  avs_s0_address,     
		input  wire        avs_s0_read,        
		output wire [31:0] avs_s0_readdata,    
		input  wire        avs_s0_write,       
		input  wire [31:0] avs_s0_writedata,   
		output wire        avs_s0_waitrequest, 
		input  wire        clock_clk,          
		input  wire        reset_reset,        
		output wire        LED_OUT             
	);assign avs_s0_readdata = 32'b00000000000000000000000000000000;




	
   reg			Reg_Status_Read;
   reg			Reg_Status_Write;
   reg [31:0] 		data_in;
   reg [31:0] 		data_out;
	reg 				led_out;


   
   
   
   assign avs_s0_waitrequest = Reg_Status_Read || Reg_Status_Write;
	assign LED_OUT = led_out;
   
   
   
   
	always @(posedge clock_clk)
	  if (reset_reset) begin
			data_in <= 32'b0;
			data_out <= 32'b0;
			Reg_Status_Write <= 1'b0;	
	  end else if (!avs_s0_waitrequest && avs_s0_write) begin
			Reg_Status_Write <= 1'b0;	
			led_out <= avs_s0_writedata[0];
			data_in <= avs_s0_writedata;
	  end else begin
			Reg_Status_Write <= 1'b0;	
	  end
	
   
   
   
   always @(posedge clock_clk)
	if (reset_reset) begin
		Reg_Status_Read <= 1'b0;	
	end else if (!avs_s0_waitrequest && avs_s0_read) begin
		Reg_Status_Read <= 1'b0;	
	end else begin
		Reg_Status_Read <= 1'b0;	
	end
	

endmodule