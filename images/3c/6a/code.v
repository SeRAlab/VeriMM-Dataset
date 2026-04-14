module JK_latch (
    input wire J,
    input wire K,
    input wire clk,
    output reg Q,
    output reg Qn
);
    always @(posedge clk) begin
        if (J && !K) begin
            Q <= 1;    // Set
        end else if (!J && K) begin
            Q <= 0;    // Reset
        end else if (J && K) begin
            Q <= ~Q;   // Toggle
        end
        Qn <= ~Q;       // Inverted output
    end
endmodule