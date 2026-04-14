module clock_gating_ff (
    input wire clk,
    input wire enable,
    input wire data_in,
    output reg data_out
);
    reg gated_clk;

    always @(clk or enable) begin
        gated_clk = clk & enable; // Gating clock based on enable signal
    end

    always @(gated_clk) begin
        if (gated_clk) begin
            data_out <= data_in; // Register data on gated clock
        end
    end
endmodule