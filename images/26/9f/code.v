module jk_flip_flop (
    input wire J,
    input wire K,
    input wire clk,
    input wire reset,
    output reg Q
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 0;
        end else begin
            case ({J, K})
                2'b00: Q <= Q;             // No change
                2'b01: Q <= 0;             // Reset
                2'b10: Q <= 1;             // Set
                2'b11: Q <= ~Q;            // Toggle
                default: Q <= Q;           // No change
            endcase
        end
    end
endmodule