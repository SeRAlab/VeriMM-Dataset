module top_module(
    input wire [7:0] in_hi,
    input wire [7:0] in_lo,
    output reg [16:0] out,
    output reg parity_bit
);reg [15:0] merged_word;

always @(*) begin
    merged_word = {in_hi, in_lo};
    parity_bit = ^merged_word;
    out = {merged_word, parity_bit};
end

endmodule