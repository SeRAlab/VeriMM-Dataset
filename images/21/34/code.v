module pll (
    input wire clk_in,
    input wire reset,
    output reg clk_out
);
    reg [7:0] phase;
    reg [7:0] frequency;
    reg [7:0] vco_out;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            phase <= 0;
            frequency <= 8'd64;  // Initial frequency
            vco_out <= 0;
            clk_out <= 0;
        end else begin
            // Phase Detector
            if (phase < frequency) begin
                phase <= phase + 1;
            end else begin
                phase <= 0;
                clk_out <= ~clk_out; // Toggle output every cycle
            end

            // VCO simulation
            if (vco_out < frequency) begin
                vco_out <= vco_out + 1;
            end else begin
                vco_out <= 0;
            end
        end
    end
endmodule