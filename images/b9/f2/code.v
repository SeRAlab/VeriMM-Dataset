module top_module(
	sw0,
	sw1,
	sw2,
	sw3,
	sw4,
	blink,
	alarm,
	led0,
	led1,
	led2,
	led3,
	led4,
	led7,
	led9
);input sw0;
input sw1;
input sw2;
input sw3;
input sw4;

input blink;

input alarm;

output led0;
output led1;
output led2;
output led3;
output led4;
output led7;
output led9;

assign led0 = sw0;
assign led1 = sw1;
assign led2 = sw2;
assign led3 = sw3;
assign led4 = sw4;
assign led9 = blink;

assign led7 = alarm ? blink : 1'b0;

endmodule