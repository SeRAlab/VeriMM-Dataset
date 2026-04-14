module phase_detector (
    input clk_ref,
    input clk_a,
    input clk_b,
    output reg [1:0] phase_out
);
    reg clk_a_prev;
    reg clk_b_prev;

    always @(posedge clk_ref) begin
        clk_a_prev <= clk_a;
        clk_b_prev <= clk_b;

        if (clk_a_prev == clk_b_prev) begin
            phase_out <= 2'b00; // In-phase
        end else if (clk_a_prev && !clk_b_prev) begin
            phase_out <= 2'b01; // clk_a is leading
        end else if (!clk_a_prev && clk_b_prev) begin
            phase_out <= 2'b10; // clk_b is leading (clk_a is lagging)
        end
    end
endmodule