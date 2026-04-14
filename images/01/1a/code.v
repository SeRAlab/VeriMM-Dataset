module jk_latch (
    input J,
    input K,
    input clk,
    output reg Q,
    output reg Qn
);
    always @(posedge clk) begin
        if (J && K) begin
            Q <= ~Q; // Toggle
        end else if (J) begin
            Q <= 1'b1; // Set
        end else if (K) begin
            Q <= 1'b0; // Reset
        end
        Qn <= ~Q; // Complement
    end
endmodule