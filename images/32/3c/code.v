module JK_latch (
    input wire J,
    input wire K,
    input wire EN,
    output reg Q
);
    always @(posedge EN) begin
        if (J == 0 && K == 0) begin
            // Do nothing, Q remains unchanged
        end else if (J == 1 && K == 0) begin
            Q <= 1; // Set Q to 1
        end else if (J == 0 && K == 1) begin
            Q <= 0; // Reset Q to 0
        end else if (J == 1 && K == 1) begin
            Q <= ~Q; // Toggle Q
        end
    end
endmodule