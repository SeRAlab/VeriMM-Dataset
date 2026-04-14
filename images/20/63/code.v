module JKFlipFlop (
    input J,
    input K,
    input clk,
    input rst,
    output reg Q
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 0;
        end else begin
            case ({J, K})
                2'b00: Q <= Q;        // No change
                2'b01: Q <= 0;        // Reset
                2'b10: Q <= 1;        // Set
                2'b11: Q <= ~Q;       // Toggle
            endcase
        end
    end
endmodule