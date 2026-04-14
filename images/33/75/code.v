module JK_flip_flop (
    input wire J,
    input wire K,
    input wire clk,
    input wire preset,
    input wire clear,
    output reg Q,
    output reg QN
);
    always @(posedge clk or posedge preset or posedge clear) begin
        if (clear) begin
            Q <= 0;
            QN <= 1;
        end else if (preset) begin
            Q <= 1;
            QN <= 0;
        end else begin
            case ({J, K})
                2'b00: Q <= Q; // No change
                2'b01: Q <= 0; // Reset
                2'b10: Q <= 1; // Set
                2'b11: Q <= ~Q; // Toggle
            endcase
            QN <= ~Q;
        end
    end
endmodule