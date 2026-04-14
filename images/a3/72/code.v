module top_module(
    input clk,    // Clocks are used in sequential circuits
    input reset,  // Synchronous active-high reset
    input d,      // D input for the D flip-flop module
    output reg q, // Output of the JK flip-flop module
    output xor_output // Output of the XOR operation
);reg d_ff_out;
reg jk_ff_out;

// D flip-flop module with synchronous reset
always @(posedge clk, posedge reset) begin
    if (reset) begin
        d_ff_out <= 6'b001101; // Reset to 0x34
    end else begin
        d_ff_out <= d;
    end
end

// JK flip-flop module
always @(posedge clk, posedge reset) begin
    if (reset) begin
        jk_ff_out <= 1'b0;
    end else begin
        case ({d_ff_out, jk_ff_out})
            2'b00: jk_ff_out <= 1'b0;
            2'b01: jk_ff_out <= 1'b1;
            2'b10: jk_ff_out <= 1'b0;
            2'b11: jk_ff_out <= ~jk_ff_out;
        endcase
    end
end

// XOR operation module
assign xor_output = d_ff_out ^ jk_ff_out;

// Output of the JK flip-flop module
assign q = jk_ff_out;

endmodule