module top_module(
    CLK,
    RST,
    DELAY_MS,
    DELAY_EN,
    DELAY_FIN
    );input CLK;
    input RST;
    input [11:0] DELAY_MS;
    input DELAY_EN;
    output DELAY_FIN;

	
	
	
	wire DELAY_FIN;
					
	reg [13:0] clk_counter = 14'b00000000000000;		
	reg [11:0] ms_counter = 12'h000;							
	
	parameter Idle = 2'd0, Hold = 2'd1, Done = 2'd2;
	reg [1:0] current_state = Idle;

	
	
	
	assign DELAY_FIN = (current_state == Done && DELAY_EN == 1'b1) ? 1'b1 : 1'b0;
	
	
	always @(posedge CLK) begin
			
			if(RST == 1'b1) begin
					current_state <= Idle;
			end
			else begin
					case(current_state)

							Idle : begin
									
									if(DELAY_EN == 1'b1) begin
											current_state <= Hold;
									end
							end
							
							Hold : begin
									
									if(ms_counter == DELAY_MS) begin
											current_state <= Done;
									end
							end
							
							Done : begin
									
									if(DELAY_EN == 1'b0) begin
											current_state <= Idle;
									end
							end
							
							default : current_state <= Idle;
							
					endcase
			end
	end
	


	
	
	always @(posedge CLK) begin
			if(current_state == Hold) begin
					if(clk_counter == 14'b10111011100000) begin		
							clk_counter <= 14'b00000000000000;
							ms_counter <= ms_counter + 1'b1;					
					end
					else begin
							clk_counter <= clk_counter + 1'b1;
					end
			end
			else begin																
					clk_counter <= 14'b00000000000000;
					ms_counter <= 12'h000;
			end
	end

endmodule