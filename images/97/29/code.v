module top_module(
	
	input wire clk,
	input wire rst,
	input wire init_OPERATION,

	output reg enable_input_internal,
	
	output wire enable_Pipeline_input,
	output reg enable_shift_reg

    );parameter [3:0] State0 = 3'd0,

	State1 = 3'd1,

	State2 = 3'd2,

	State3 = 3'd3,

	State4 = 3'd4,

	State5= 3'd5,

	State6 = 3'd6,

	State7 = 3'd7;



reg [2:0] state_reg, state_next;


always @(posedge clk, posedge rst)
	if(rst)
		state_reg <= State0;
	else
		state_reg <= state_next;


always @*
	begin
			
	
	state_next = state_reg; 

	enable_input_internal=1; 
	enable_shift_reg = 0;
	case(state_reg)

		State0:
			begin
				

				
				if(init_OPERATION)
					state_next = State1; 
				else begin
					state_next = State0; 
				end

			end

		State1:
			begin
				
				enable_input_internal=1;
				enable_shift_reg = 1;
				
				state_next = State6;
			end

		State6:
			begin
				
				enable_input_internal=1;
				enable_shift_reg = 1;
				
				state_next = State2;
			end


		State2:
			begin
				
				enable_input_internal=1;
				enable_shift_reg = 1;
				
				state_next = State3;
			end

		State3:
			begin
				
				enable_input_internal=0;
				enable_shift_reg = 1;
				
				state_next = State4;
			end

		State4:
			begin
				
				enable_input_internal=0;
				enable_shift_reg = 1;
				
				state_next = State5;
			end

		State5:
			begin
				
				enable_input_internal=0;
				enable_shift_reg = 1;
				
				
				if (init_OPERATION) begin
					state_next = State1;
				end else begin
					state_next = State0;
				end
			end

		
		
		
		
		
		
		
		

		
		
		
		
		
		
		
		
		default:
			begin
				state_next =State0;

			end
	endcase
end


assign  enable_Pipeline_input = enable_input_internal & init_OPERATION;

endmodule