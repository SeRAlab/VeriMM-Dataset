module JK_flip_flop (
    input clk,
    input J,
    input K,
    output reg Q,
    output reg Qn
);
    always @(posedge clk) begin
        if (J && K) begin
            Q <= ~Q; // Toggle
        end else if (J) begin
            Q <= 1; // Set
        end else if (K) begin
            Q <= 0; // Reset
        end
        Qn <= ~Q; // Complement of Q
    end
endmodule