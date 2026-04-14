module top_module(error, clk, req, ack, reset);output reg error;

input clk, req, ack, reset;

reg [2:0] state;

initial
begin
	state = 3'b000;
	error = 1'b0;
end

always @(posedge clk)
begin
	case (state)
		3'b000: 
		begin
			if (~req && ~ack)
				state = 3'b000;
			else if (req && ~ack)
				state = 3'b001;
			else
			begin
				state = 3'b100;
				error = 1'b1;
			end
		end
		
		3'b001:
		begin
			if (req && ~ack)
				state = 3'b001;
			else if (req && ack)
				state = 3'b010;
			else
			begin
				state = 3'b100;
				error = 1'b1;
			end
		end
		
		3'b010:
		begin
			if (req && ack)
				state = 3'b010;
			else if (~req && ack)
				state = 3'b011;
			else
			begin
				state = 3'b100;
				error = 1'b1;
			end
		end
		
		3'b011:
		begin
			if (~req && ack)
				state = 3'b011;
			else if (~req && ~ack)
				state = 3'b000;
			else
			begin
				state = 3'b100;
				error = 1'b1;
			end
		end
		
		3'b100:
		begin
			if (reset)
			begin
				state = 3'b000;
				error = 1'b0;
			end
		end
		
		default:
		begin
			state = 3'b100;
			error = 1'b1;
		end
	endcase
end

endmodule