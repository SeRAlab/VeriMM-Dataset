module top_module(
    input clk_in1,
    input reset,
    output clk_out1
);parameter DIVIDER = 4; // Change this to 2, 4, 8, 16 for different clock frequencies
reg [31:0] counter = 0;
reg clk_out1_reg = 0;

always @(posedge clk_in1, posedge reset) begin
    if (reset) begin
        counter <= 0;
        clk_out1_reg <= 0;
    end else begin
        counter <= counter + 1;
        if (counter == (clk_in1 / DIVIDER) - 1) begin
            counter <= 0;
            clk_out1_reg <= ~clk_out1_reg;
        end
    end
end

assign clk_out1 = clk_out1_reg;

endmodule