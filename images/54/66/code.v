module top_module(
	output reg gnt,
	output reg [1:0] state,
	input dly,
	input done,
	input req,
	input clk,
	input rst_n
);// Define the states of the FSM
	parameter [1:0] IDLE = 2'b00,
					BBUSY = 2'b01,
					BWAIT = 2'b10,
					BFREE = 2'b11;

	// Declare the next state variable
	reg [1:0] next;

	// Initialize the state variable
	initial begin
		state = IDLE;
		next = IDLE;
	end

	// Assign the next state to the current state on the positive clock edge
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			state <= IDLE;
			next <= IDLE;
		end
		else begin
			state <= next;
		end
	end

	// Implement the FSM logic using a case statement
	always @* begin
		next = 2'bx;
		gnt = 1'b0;

		case (state)
			IDLE: begin
				if (req) begin
					next = BBUSY;
				end
				else begin
					next = IDLE;
				end
			end
			BBUSY: begin
				gnt = 1'b1;
				if (!done) begin
					next = BBUSY;
				end
				else begin
					if (dly) begin
						next = BWAIT;
					end
					else begin
						next = BFREE;
					end
				end
			end
			BWAIT: begin
				gnt = 1'b1;
				if (!dly) begin
					next = BFREE;
				end
				else begin
					next = BWAIT;
				end
			end
			BFREE: begin
				if (req) begin
					next = BBUSY;
				end
				else begin
					next = IDLE;
				end
			end
			default: begin
				next = IDLE;
			end
		endcase
	end

endmodule