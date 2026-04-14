module phase_detector (
    input wire clk_ref,
    input wire clk_in,
    output reg [1:0] phase_out
);
    reg clk_ref_d, clk_in_d;

    always @(posedge clk_ref) begin
        clk_ref_d <= clk_ref;
        clk_in_d <= clk_in;

        if (clk_ref_d && clk_in_d) begin
            phase_out <= 2'b00; // In phase
        end else if (clk_ref_d && !clk_in_d) begin
            phase_out <= 2'b10; // Lagging
        end else if (!clk_ref_d && clk_in_d) begin
            phase_out <= 2'b01; // Leading
        end
    end
endmodule