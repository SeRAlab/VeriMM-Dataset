module JK_FlipFlop (
    input wire J,
    input wire K,
    input wire clk,
    output reg Q,
    output reg Q_not
);

always @(posedge clk) begin
    case ({J, K})
        2'b00: Q <= Q;        // No change
        2'b01: Q <= 0;        // Reset
        2'b10: Q <= 1;        // Set
        2'b11: Q <= ~Q;       // Toggle
    endcase
    Q_not <= ~Q;             // Complement of Q
end

endmodule