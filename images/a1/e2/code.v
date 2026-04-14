module top_module(
reset,
clock_in,
counter,
clock_out,
halt
);parameter BITS		=  5;
parameter DIM		=	31;

input		reset, clock_in, halt;
output reg [BITS:0]	counter;
output reg	clock_out;

reg		[1:0] state;
reg      [1:0] next_state;

parameter IDLE	= 3'b000;
parameter LOW	= 3'b001;
parameter HIGH = 3'b010;

always @ (state)
begin : FSM_COMBO
	case(state)
		IDLE:
				next_state = LOW;
		LOW :
				next_state = HIGH;
		HIGH:
				if(counter < DIM)
					next_state = HIGH;
				else 
					next_state = LOW;
		default:
				next_state = IDLE;
	endcase
end

always @ (negedge clock_in)
begin : FSM_SEQ
	if (reset)
		state <= IDLE;
	else
		state <= next_state;
end

always @ (negedge clock_in)
begin
	if(halt==1)
		counter <= counter;
	else if(state==HIGH)
		counter <= counter + 1;
	else
		counter <= 0;
end

always @ (negedge clock_in)
begin
	case(state)
	IDLE:		clock_out <=  1'b1;
	LOW :		clock_out <=  1'b0;
	HIGH:		clock_out <=  1'b1;
	default: clock_out <=  1'b1;
	endcase
end
endmodule