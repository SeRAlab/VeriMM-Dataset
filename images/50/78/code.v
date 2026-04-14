module top_module(
		input	CLKDIV, 
		input	RST,
		input [7:0]	DATA_IN,


		output reg	data_valid,
		output reg [7:0]	data_out
   );reg [1:0] frame_decap_state;
	localparam IDLE		= 2'b00;
	localparam HEADER		= 2'b01;
	localparam DATA_OUT	= 2'b10;

	reg [7:0] data_reg;
	reg [4:0] counter;
	always@(posedge CLKDIV) data_reg[7:0] <= DATA_IN[7:0];

	always@(posedge CLKDIV) begin
		if (RST) begin
			counter[4:0]		<= 5'h00;
			data_valid			<= 1'b0;
			data_out[7:0]		<= 8'h00;
			frame_decap_state <= IDLE;
		end else begin
			case (frame_decap_state)
				IDLE: begin
					counter[4:0]	<= 5'h00;
					data_valid		<= 1'b0;
					data_out[7:0]	<= 8'h00;
					
					if ( data_reg[7:0] == 8'hF5 )	
						frame_decap_state <= HEADER;
					else
						frame_decap_state <= IDLE;					
				end
				
				HEADER: begin
					counter[4:0]	<= 5'h00;
					data_valid		<= 1'b0;
					data_out[7:0]	<= 8'h00;
					
					if ( data_reg[7:0] == 8'h1D )	


						frame_decap_state <= DATA_OUT;
					else if ( data_reg[7:0] == 8'hF5 )
						frame_decap_state <= HEADER;	
					else
						frame_decap_state <= IDLE;	
				end
				
				DATA_OUT: begin
					counter[4:0]	<= counter[4:0] + 5'h01;
					data_valid		<= 1'b1;
					data_out[7:0]	<= data_reg[7:0];
					
					if (counter >= 5'h1C)
						frame_decap_state <= IDLE;
					else
						frame_decap_state <= DATA_OUT;
				end
				
				default: begin
					counter[4:0]	<= 5'h00;
					data_valid		<= 1'b0;
					data_out[7:0]	<= 8'h00;
					frame_decap_state <= IDLE;					
				end
				
			endcase
		end
	end

endmodule