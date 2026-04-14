module jk_flip_flop (
    input wire J,
    input wire K,
    input wire CLK,
    input wire RESET,
    output reg Q
);
    always @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            Q <= 0;
        end else begin
            case ({J, K})
                2'b00: Q <= Q;           // No change
                2'b01: Q <= 0;           // Reset (J=0, K=1)
                2'b10: Q <= 1;           // Set (J=1, K=0)
                2'b11: Q <= ~Q;          // Toggle (J=1, K=1)
            endcase
        end
    end
endmodule