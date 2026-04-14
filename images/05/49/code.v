module jk_latch (
    input J,
    input K,
    input clk,
    output reg Q,
    output reg Qn
);
    always @(posedge clk) begin
        if (J && !K) begin
            Q <= 1;
            Qn <= 0;
        end else if (!J && K) begin
            Q <= 0;
            Qn <= 1;
        end else if (J && K) begin
            Q <= ~Q; // Toggle
            Qn <= ~Qn;
        end
        // If J=0 and K=0, Q and Qn remain unchanged
    end
endmodule