module top_module(
    input clk,    // Clocks are used in sequential circuits
    input rst,    // Added active high synchronous reset input
    input d,      // Data input
    output reg q  // Single-bit output stored in a register with active high synchronous reset
);reg t; // T input for the T flip-flop

// Combinational circuit to generate T input based on clock and data inputs
always @ (posedge clk) begin
    t <= d ^ q; // XOR gate generates T input
end

// T flip-flop with active high synchronous reset
always @ (posedge clk or posedge rst) begin
    if (rst) begin
        q <= 1'b0;
    end else begin
        q <= t;
    end
end

endmodule