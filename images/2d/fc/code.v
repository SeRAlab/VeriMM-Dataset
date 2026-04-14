module phase_detector (
    input wire clk,
    input wire input_a,
    input wire input_b,
    output reg output_phase
);
    reg prev_a, prev_b;

    always @(posedge clk) begin
        prev_a <= input_a;
        prev_b <= input_b;
        if (prev_a == input_a && prev_b == input_b) begin
            output_phase <= 1'b1; // Inputs are in phase
        end else begin
            output_phase <= 1'b0; // Inputs are not in phase
        end
    end
endmodule