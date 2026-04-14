module jk_flip_flop (
    input wire J,
    input wire K,
    input wire CLK,
    input wire RST,
    output reg Q,
    output wire Qn
);
    assign Qn = ~Q; // Inverted output

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Q <= 1'b0; // Reset Q to 0
        end else begin
            case ({J, K})
                2'b00: Q <= Q;        // No change
                2'b01: Q <= 1'b0;     // Reset
                2'b10: Q <= 1'b1;     // Set
                2'b11: Q <= ~Q;       // Toggle
            endcase
        end
    end
endmodule