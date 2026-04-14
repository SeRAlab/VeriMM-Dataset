module top_module(
    input [3:0] in,
    input wire [15:0] in_word,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo,
    output reg [1:0] pos, // Priority encoder output
    output reg flag // Priority encoder flag indicating whether input is zero or not
);// Priority Encoder
wire [3:0] in_inv = ~in; // Inverted input
wire [3:0] in_or_inv = in | in_inv; // OR of input and inverted input
wire [3:0] in_or_inv_inv = ~in_or_inv; // Inverted OR of input and inverted input
wire [1:0] pos_temp = {in_or_inv_inv[3], in_or_inv_inv[2]}; // Temporary position output
always @* begin
    pos = (in_or_inv_inv[1]) ? 1 : pos_temp; // Final position output
end
assign flag = (in == 0) ? 1 : 0; // Flag indicating whether input is zero or not

// Barrel Shifter
wire [7:0] in_word_lo = in_word[7:0]; // Lower byte of input word
wire [7:0] in_word_hi = in_word[15:8]; // Upper byte of input word
reg [7:0] out_lo_temp, out_hi_temp; // Temporary output variables

// Functional Module
always @* begin
    if (flag) begin // Input is zero
        out_lo_temp = in_word_lo + in_word_hi; // Add the two bytes
        out_hi_temp = out_lo_temp; // Set both outputs to the sum
    end else begin // Input is non-zero
        if (pos == 0) begin // Highest bit is in lower byte
            out_lo_temp = in_word_lo; // Set lower output to lower byte
            out_hi_temp = 8'b0; // Set upper output to zero
        end else begin // Highest bit is in upper byte
            out_lo_temp = 8'b0; // Set lower output to zero
            out_hi_temp = in_word_hi; // Set upper output to upper byte
        end
    end
end

assign out_lo = out_lo_temp;
assign out_hi = out_hi_temp;

endmodule