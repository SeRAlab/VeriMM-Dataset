module JK_FF (
    input wire J,
    input wire K,
    input wire clock,
    input wire RESET,
    input wire PRESET,
    output reg Q
);
    always @(posedge clock or posedge RESET or posedge PRESET) begin
        if (RESET) begin
            Q <= 0;
        end else if (PRESET) begin
            Q <= 1;
        end else begin
            case ({J, K})
                2'b00: Q <= Q; // No change
                2'b01: Q <= 0; // Reset
                2'b10: Q <= 1; // Set
                2'b11: Q <= ~Q; // Toggle
            endcase
        end
    end
endmodule