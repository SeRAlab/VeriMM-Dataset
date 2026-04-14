module NANO_PROG_COUNTER (input [5:0] MCR_IN , output [5:0] NANO_PRE_OUT);
reg [5:0] NANO_PRE_OUT_r;
assign NANO_PRE_OUT = NANO_PRE_OUT_r;
always@(MCR_IN)
begin
NANO_PRE_OUT_r <= MCR_IN;
end
endmodule