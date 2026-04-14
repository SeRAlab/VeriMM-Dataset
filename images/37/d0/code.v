module JK_latch (
    input J,
    input K,
    input CLK,
    output reg Q,
    output reg Qn
);
    always @(posedge CLK) begin
        if (J == 1'b0 && K == 1'b0) begin
            // Maintain state
            Q <= Q;
        end else if (J == 1'b1 && K == 1'b0) begin
            // Set Q high
            Q <= 1'b1;
        end else if (J == 1'b0 && K == 1'b1) begin
            // Set Q low
            Q <= 1'b0;
        end else if (J == 1'b1 && K == 1'b1) begin
            // Toggle Q
            Q <= ~Q;
        end
        // Update Qn as the complement of Q
        Qn <= ~Q;
    end
endmodule