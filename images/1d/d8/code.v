module frac_n_pll (
    input clk,
    input reset,
    input [15:0] input_frequency,
    output reg [15:0] output_frequency
);
    reg [15:0] n_value;
    parameter FRACTIONAL_PART = 2; // Example fractional part

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_frequency <= 0;
            n_value <= 0;
        end else begin
            n_value <= input_frequency / (1 + FRACTIONAL_PART);
            output_frequency <= n_value;
        end
    end
endmodule