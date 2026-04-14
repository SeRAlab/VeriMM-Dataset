module pll_4x (
    input wire clk_in,
    input wire enable,
    output reg clk_out
);
    reg [1:0] phase_counter;
    reg vco_clk;
    
    always @(posedge clk_in) begin
        if (enable) begin
            phase_counter <= phase_counter + 1;
            if (phase_counter == 2'b11) begin
                vco_clk <= ~vco_clk;
            end
        end
    end

    always @(posedge clk_in) begin
        if (enable) begin
            clk_out <= vco_clk;
        end
    end

    initial begin
        phase_counter = 0;
        vco_clk = 0;
        clk_out = 0;
    end
endmodule