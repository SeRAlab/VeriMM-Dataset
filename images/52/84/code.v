module top_module(
    input [31:0] in,
    output reg out
);reg [7:0] byte0, byte1, byte2, byte3;
reg [31:0] reversed;

// Byte reversal module
assign byte0 = in[7:0];
assign byte1 = in[15:8];
assign byte2 = in[23:16];
assign byte3 = in[31:24];

assign reversed = {byte3, byte2, byte1, byte0}; // Corrected order for byte reversal

// XOR gate for the final output
always @(*) begin
    out = reversed[31:24] ^ reversed[23:16] ^ reversed[15:8] ^ reversed[7:0];
end

endmodule