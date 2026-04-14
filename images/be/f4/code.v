module top_module(
	input [7:0] d_in,
	input push_cb,
	input pop_cb,
	input rst,
	input clock,
	output reg [7:0] d_out,
	output reg empty_cb,
	output reg full_cb
);reg [7:0] buffer [0:3];
reg [1:0] head = 2'd0;
reg [1:0] tail = 2'd0;

initial begin
	empty_cb = 1'b1;
	full_cb = 1'b0;
end

always @(posedge clock) begin
	if (rst) begin
		head <= 2'd0;
		tail <= 2'd0;
		empty_cb <= 1'b1;
		full_cb <= 1'b0;
	end else if (push_cb && !pop_cb && !full_cb) begin
		buffer[head] <= d_in;
		head <= (head == 2'd3) ? 2'd0 : head + 2'd1;
		empty_cb <= 1'b0;
		full_cb <= (head + 1'b1) == tail ? 1'b1 : 1'b0;
	end else if (!push_cb && pop_cb && !empty_cb) begin
		d_out <= buffer[tail];
		buffer[tail] <= 8'd0;
		tail <= (tail == 2'd3) ? 2'd0 : tail + 2'd1;
		full_cb <= 1'b0;
		empty_cb <= (head == tail) ? 1'b1 : 1'b0;
	end
end

endmodule