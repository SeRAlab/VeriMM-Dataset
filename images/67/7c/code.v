module top_module(
		input wire clk,
		input wire reset,

	
		input wire start_strobe_din,

	
		output wire enable_dout,
		output wire source_dout,
		output wire active_dout,
		output reg  round_shift_dout,

		output wire done_strobe_dout
    );localparam IDLE 	= 1'b0;
	localparam ACTIVE 	= 1'b1;



	reg [3:0]	round_counter;



	reg state_reg;
	reg state_next;

	
		always @(posedge clk)
			if(reset)
				state_reg <= IDLE;
			else
				state_reg <= state_next;

	
		always @(*)
			begin
				state_next = state_reg;
				case (state_reg)
					IDLE: 		if (start_strobe_din)
									state_next = ACTIVE;
					
					ACTIVE:	if (round_counter == 4'b1111)
									state_next = IDLE;
				endcase 
			end


	
		always @(posedge clk)
			if (state_reg)
				round_counter <= round_counter + 1'b1;
			else
				round_counter <= {4{1'b0}};


	

		
		assign enable_dout = (state_next | state_reg) ? 1'b1 : 1'b0;

		
			always @(*)
				case (round_counter)
					4'd0 : round_shift_dout = 1'b0;
					4'd1 : round_shift_dout = 1'b0;
					4'd8 : round_shift_dout = 1'b0;
					4'd15: round_shift_dout = 1'b0;

					default : round_shift_dout = 1'b1;

				endcase 

		
			assign source_dout = (state_reg) ? 1'b1 : 1'b0;

		
			assign done_strobe_dout = (&round_counter) ? 1'b1 : 1'b0;

		
			assign active_dout = (state_reg) ? 1'b1 : 1'b0;


	
		wire [6*8:0]	estado_presente;
		wire [6*8:0]	estado_siguiente;

		assign estado_presente  = (state_reg)  ? "ACTIVE" : "IDLE";
		assign estado_siguiente = (state_next) ? "ACTIVE" : "IDLE";


endmodule