module PLL(
    input wire clk_in,
    input wire reset,
    output reg clk_out
);
    reg [1:0] phase_count;
    reg vco_clk;
    
    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            phase_count <= 2'b00;
            vco_clk <= 1'b0;
            clk_out <= 1'b0;
        end else begin
            phase_count <= phase_count + 1;
            if (phase_count == 2'b11) begin
                vco_clk <= ~vco_clk; // Toggle VCO clock every 4 input clocks
            end
            clk_out <= vco_clk; // Output the VCO clock
        end
    end
endmodule