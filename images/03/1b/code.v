module JK_flip_flop (
    input wire J,
    input wire K,
    input wire clk,
    input wire reset_n,
    output reg Q
);
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) 
            Q <= 0;
        else begin
            case ({J, K})
                2'b00: Q <= Q;          // No change
                2'b01: Q <= 0;          // Reset
                2'b10: Q <= 1;          // Set
                2'b11: Q <= ~Q;         // Toggle
            endcase
        end
    end
endmodule