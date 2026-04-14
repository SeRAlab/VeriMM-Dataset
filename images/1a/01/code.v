module sr_flip_flop (
    input wire clk,
    input wire S,
    input wire R,
    input wire reset,
    output reg Q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 1'b0;
        end else begin
            case ({S, R})
                2'b00: Q <= Q;        // No change
                2'b01: Q <= 1'b0;     // Reset
                2'b10: Q <= 1'b1;     // Set
                2'b11: Q <= 1'bx;     // Invalid state
            endcase
        end
    end
endmodule