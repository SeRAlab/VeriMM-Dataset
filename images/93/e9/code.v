module top_module(
    input clk,
    input reset,   // Synchronous active-high reset
    input [7:0] in_hi,  // Upper byte input for the combinational circuit
    input [7:0] in_lo,  // Lower byte input for the combinational circuit
    output [15:0] out  // Output from the functional module
);// Combinational circuit to combine two input bytes into a half-word
    wire [15:0] half_word = {in_hi, in_lo};

    // 4-digit binary up-counter
    reg [3:0] counter_in;
    reg [15:0] counter_out;

    always @(posedge clk) begin
        if (reset) begin
            counter_in <= 4'b0000;
            counter_out <= 16'b0000000000000000;
        end else begin
            counter_in <= counter_in + 1;
            counter_out <= counter_in;
        end
    end

    // Functional module to output the sum of the half-word and the counter
    assign out = half_word + counter_out;

endmodule