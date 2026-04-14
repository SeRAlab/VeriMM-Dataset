module top_module(
    input clk, // Clock
    input clr_n, // Active low, asynchronous reset
    input j, // J input
    input k, // K input
    output reg q, // Output
    output reg q_n // Inverted output
);// Look at the falling edge of clock for state transitions
always @(negedge clk or negedge clr_n) begin
    if (~clr_n) begin
        // This is the reset condition. Most synthesis tools
        // require an asynchronous reset to be defined this
        // way.
        q <= 1'b0;
    end
    else begin
        case ({j,k})
            2'b00: q <= q; // HOLD
            2'b01: q <= 1'b0; // RESET
            2'b10: q <= 1'b1; // SET
            2'b11: q <= ~q; // TOGGLE
        endcase
    end
end

// Assign statements
assign q_n = ~q;

endmodule