module JK_flip_flop (
    input wire J,
    input wire K,
    input wire CLK,
    output reg Q
);
    always @(posedge CLK) begin
        if (J == 0 && K == 0) begin
            Q <= Q; // No change
        end else if (J == 1 && K == 0) begin
            Q <= 1; // Set
        end else if (J == 0 && K == 1) begin
            Q <= 0; // Reset
        end else if (J == 1 && K == 1) begin
            Q <= ~Q; // Toggle
        end
    end
endmodule