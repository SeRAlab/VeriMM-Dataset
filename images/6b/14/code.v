module top_module(clk, reset, init_done);input clk, reset, init_done;


reg current_state;
reg next_state;

parameter state_init   = 1'b0,
          state_write  = 1'b1;

always @ (posedge clk or posedge reset)
begin
	if(reset)
		current_state <= state_init;
	else
		current_state <= next_state;
end


always @ (current_state or init_done)
begin
	case(current_state)
    state_init : next_state = init_done ? state_write : state_init;
		state_write: next_state = state_write;
		default: next_state = 1'bX; 
	endcase
end

endmodule