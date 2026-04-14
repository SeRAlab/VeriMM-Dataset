module top_module(
		input reset,
		input clk,
		input cmd,
		input cmd_ack,
		output reg cmd_buffer = 1'b0
    );parameter IDLE_ST = 2'b00;
parameter VALID_ST = 2'b01;
parameter WAIT_ST = 2'b10;

reg [1:0] st = IDLE_ST;

always @(posedge clk)
if(reset)
begin
cmd_buffer <= 1'b0;
st <= IDLE_ST;
end else case(st)
IDLE_ST : begin
if(cmd)
st <= VALID_ST;
else
st <= IDLE_ST;

cmd_buffer <= 1'b0;
end

VALID_ST : begin
if(cmd_ack)
begin
st <= WAIT_ST;
cmd_buffer <= 1'b0;
end
else
begin
st <= VALID_ST;
cmd_buffer <= 1'b1;
end

end

WAIT_ST : begin
if(cmd)
st <= WAIT_ST;
else
st <= IDLE_ST;

cmd_buffer <= 1'b0;
end

default : begin
cmd_buffer <= 1'b0;

st <= IDLE_ST;
end

endcase

endmodule