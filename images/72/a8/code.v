module top_module(
	input CLK,
	output LED1,
	output LED2,
	output LED3,
	output LED4,
	output P1A7,
	output P1A8,
	output P1A9,
	output P1A10
);localparam N = 24;  

reg [N:0] counter = 0;
always @(posedge CLK)
  counter <= counter + 1;

assign {LED4, LED3, LED2, LED1} = {counter[23],counter[23],counter[23],counter[23]};

endmodule