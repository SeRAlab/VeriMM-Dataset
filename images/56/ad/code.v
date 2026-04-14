module top_module(
	clk,
	rst_n,
	col_n,
	cycle,
	duty,
	out
);parameter OUT0        = 1'b0;
parameter CYCLE_WIDTH = 8;
parameter DUTY_WIDTH  = CYCLE_WIDTH;

input                  clk;
input                  rst_n;
input                  col_n;
input[CYCLE_WIDTH-1:0] cycle;
input[DUTY_WIDTH -1:0] duty;
output                 out;

reg                   out;
wire                  out0;
reg [CYCLE_WIDTH-1:0] cnt;
wire[CYCLE_WIDTH-1:0] r_cycle;
wire[DUTY_WIDTH -1:0] r_duty;

assign r_cycle = cycle - 1'b1;
assign r_duty  = duty  - 1'b1;
assign out0    = col_n ? OUT0 : (~OUT0);

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		cnt <= 1'b0;
		out <= out0;
	end else begin
		cnt <= cnt + 1'b1;
		if(cnt == r_duty) begin
			out <= ~out0;
		end else if(cnt == r_cycle) begin
			out <= out0;
			cnt <= 1'b0;
		end
	end
end

endmodule