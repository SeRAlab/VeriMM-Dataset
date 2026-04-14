module top_module(	
				
				
				dat_i, 
				adr_i, 
				we_i,
				stb_i,
				
				dat_o, 				
				ack_o,

				clk,
				rst,
				BTN,
				SW,
				
				
				
				
				
				
				
				
				
				led_out,
				counter_out,
				counter0_out,
				counter1_out,
				counter2_out,

				
				
				
				
				
				
				
				
				GPIOffffff00_we,
				GPIOfffffe00_we,
				counter_we,
				
				Peripheral_in
				);input wire [31:0] dat_i;
	input wire [31:0] adr_i;
	input wire we_i;
	input wire stb_i;
	output reg [31:0] dat_o = 0;
	output ack_o;

	
	input  wire 		clk, rst;
	input  wire			counter0_out, counter1_out, counter2_out;
	input  wire	[ 3: 0] BTN;
	
	input  wire	[ 7: 0] SW, led_out;
	
	
	
	input  wire	[31: 0] counter_out;

	
	
	
	output reg 				GPIOfffffe00_we, GPIOffffff00_we, counter_we;
	
	output reg	[31: 0] Peripheral_in;
	
	



	wire 				counter_over;
	reg 	[31: 0] 	Cpu_data2bus, Cpu_data4bus;
	wire					wea;
	
	
	


	
	
	
	
	
	

	
	

	assign ack_o = stb_i;
	
	
	assign wea = stb_i & ack_o & we_i;
	always @(posedge clk) begin
		if(stb_i & ack_o) begin
			if(we_i) begin 
				Cpu_data2bus <= dat_i;
			end
			else begin 
				dat_o <= Cpu_data4bus;
			end
		end
	end

	
	always @* begin
		
		
		
		counter_we  				= 0;
		GPIOffffff00_we 			= 0;
		GPIOfffffe00_we 			= 0;
		
		
		
		
		
		Peripheral_in 				= 32'h0;
		Cpu_data4bus 				= 32'h0;

		casex(adr_i[31:8])
			
			
			
			
			
			

			
			
			
			
			
			
			

			
			
			
			
			

			24'hfffffe: begin 
				GPIOfffffe00_we 	= wea;
				Peripheral_in 		= Cpu_data2bus;
				Cpu_data4bus 		= counter_out; 
			end

			24'hffffff: begin 
				if( adr_i[2] ) begin 
					counter_we 		= wea;
					Peripheral_in 	= Cpu_data2bus; 
					Cpu_data4bus 	= counter_out; 
				end
				else begin 		
					GPIOffffff00_we = wea;
					Peripheral_in 	= Cpu_data2bus; 
					Cpu_data4bus 	= {counter0_out, counter1_out, counter2_out, 9'h000, led_out, BTN, SW};
				end
	 		end
	 	endcase
	end 

endmodule