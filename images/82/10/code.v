module top_module(externalInterrupts, PSWI, internalInterrupts, address, interruptNumber, interruptPresent);parameter WIDTH			= 16;
parameter ADDRESS_WIDTH	= 32;
parameter NUMBER_WIDTH	= 4;

input wire [WIDTH - 1 : 0] externalInterrupts, internalInterrupts;
input wire 						PSWI;

output reg [ADDRESS_WIDTH - 1 : 0] address;
output reg [NUMBER_WIDTH - 1  : 0] interruptNumber;
output reg								  interruptPresent;

integer i;
always @(*) begin
	address 				= {32{1'b0}};
	interruptPresent	= 1'b0;
	interruptNumber	= 1'b0;
	for (i = WIDTH - 1; i >= 0; i = i - 1) begin
		if ((externalInterrupts[i] == 1'b1 && PSWI) || internalInterrupts[i]) begin
			address 				= {i, 2'b00};
			interruptPresent	= 1'b1;
			interruptNumber	= i;
		end
	end
end

endmodule