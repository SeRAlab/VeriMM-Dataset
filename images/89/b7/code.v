module top_module(
    input [15:0] D0i,
    input [15:0] D1i,
    input [15:0] D2i,
    input [15:0] D3i,
    input [15:0] D4i,
    input [15:0] D5i,
    input [15:0] D6i,
    input [15:0] D7i,
    input [2:0] ADR,
    output wire [15:0] Dout
    );assign Dout = (ADR == 0)?D0i:
					(ADR == 1)?D1i:
					(ADR == 2)?D2i:
					(ADR == 3)?D3i:
					(ADR == 4)?D4i:
					(ADR == 5)?D5i:
					(ADR == 6)?D6i: D7i;

endmodule