module top_module(sda, scl, ioout, adr, reset, debug);inout sda;	
	input scl;
	input reset;
	input [6:0] adr; 
	output reg [7:0] ioout;
	output debug;
			
	reg start = 1; 
	reg adr_match = 1; 
	reg [4:0] ct = -1; 
	reg [6:0] address = -1;
	reg [7:0] data_rx = -1;	

	
	wire ct_reset;
	wire m1_pre_neg ;
	assign m1_pre_neg = !ct_reset;
	wire m1 ;
	assign m1 = !m1_pre_neg;

   always @(negedge sda or negedge m1)
      if (!m1) begin		
         start <= 1'b1;
      end else 
		begin
         start <= !scl;	
      end

	
	
	
	
	
	
	
		

	always @(posedge scl or negedge reset) 
		begin
			if (!reset)
				begin
					ioout <= -1;
					address <= -1;
					data_rx <= -1;
				end
			else 
			begin
					case (ct)
						5'h00	: address[6] <= sda;
						5'h01	: address[5] <= sda;
						5'h02	: address[4] <= sda;
						5'h03	: address[3] <= sda;
						5'h04	: address[2] <= sda;
						5'h05	: address[1] <= sda;
						5'h06	: address[0] <= sda;
						
									
						5'h09	: data_rx[7] <= sda;
						5'h0a	: data_rx[6] <= sda;
						5'h0b	: data_rx[5] <= sda;
						5'h0c	: data_rx[4] <= sda;
						5'h0d	: data_rx[3] <= sda;
						5'h0e	: data_rx[2] <= sda;
						5'h0f	: data_rx[1] <= sda;
						5'h10	: data_rx[0] <= sda;
								
						5'h11	: if (address == adr) ioout <= data_rx;
					endcase
			end
		end

	assign ct_reset = start & reset; 
	always @(negedge scl or negedge ct_reset)
		begin
			if (!ct_reset) ct <= -1;
			else ct <= ct +1;  
		end
		

	always @(ct, adr, address)
		begin
			case (ct)
				5'h08	: if (address == adr) adr_match <= 0;  
						
				5'h11	: if (address == adr) adr_match <= 0;  
								
				default	: 	adr_match <= 1;							
			endcase
		end

	assign debug = adr_match;
		
	assign sda = adr_match ? 1'bz : 1'b0;
	

endmodule