module sr_flip_flop (
    input wire S,
    input wire R,
    input wire CLK,
    input wire RESET,
    output reg Q
);

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        Q <= 0;
    end else begin
        case ({S, R})
            2'b00: Q <= Q; // No change
            2'b01: Q <= 0; // Reset
            2'b10: Q <= 1; // Set
            2'b11: Q <= 1'bx; // Invalid state
        endcase
    end
end

endmodule