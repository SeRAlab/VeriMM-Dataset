module jk_flip_flop (
    input J,
    input K,
    input clk,
    output reg Q
);
    always @(posedge clk) begin
        if (J && ~K) begin
            Q <= 1; // Set
        end else if (~J && K) begin
            Q <= 0; // Reset
        end else if (J && K) begin
            Q <= ~Q; // Toggle
        end
    end
endmodule