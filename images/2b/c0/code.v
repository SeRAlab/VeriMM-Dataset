module jk_flip_flop (
    input wire J,
    input wire K,
    input wire clk,
    input wire preset,
    input wire clear,
    output reg Q
);
    always @(posedge clk or posedge preset or posedge clear) begin
        if (clear) begin
            Q <= 1'b0; // Reset Q to 0
        end else if (preset) begin
            Q <= 1'b1; // Set Q to 1
        end else begin
            case ({J, K})
                2'b00: Q <= Q;       // No change
                2'b01: Q <= 1'b0;    // Reset
                2'b10: Q <= 1'b1;    // Set
                2'b11: Q <= ~Q;      // Toggle
            endcase
        end
    end
endmodule