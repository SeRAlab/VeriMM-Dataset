module JK_FF (
    input clk,
    input reset,
    input J,
    input K,
    output reg Q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 0;
        end else begin
            case ({J, K})
                2'b00: Q <= Q;          // Hold state
                2'b01: Q <= 0;          // Reset
                2'b10: Q <= 1;          // Set
                2'b11: Q <= ~Q;         // Toggle
            endcase
        end
    end
endmodule