module top_module(
    input [31:0] in,
    output [31:0] out
);reg [31:0] shift_reg;

// Shift input vector and load into shift register
always @(*) begin
    shift_reg[31:24] = in[7:0];
    shift_reg[23:16] = in[15:8];
    shift_reg[15:8] = in[23:16];
    shift_reg[7:0] = in[31:24];
end

// Invert bits of each byte using XOR
reg [7:0] byte0, byte1, byte2, byte3;
always @(*) begin
    byte0 = shift_reg[7:0] ^ 8'hFF;
    byte1 = shift_reg[15:8] ^ 8'hFF;
    byte2 = shift_reg[23:16] ^ 8'hFF;
    byte3 = shift_reg[31:24] ^ 8'hFF;
end

// Concatenate inverted bytes in reverse order
assign out = {byte3, byte2, byte1, byte0};

endmodule