module SR_latch (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Qn
);
    always @(posedge clk) begin
        if (S && R) begin
            Q <= 0;  // Invalid state
        end else if (S) begin
            Q <= 1;  // Set
        end else if (R) begin
            Q <= 0;  // Reset
        end
        Qn <= ~Q;  // Qn is the complement of Q
    end
endmodule