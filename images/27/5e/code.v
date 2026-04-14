module pll_2x (
    input wire clk_in,
    input wire enable,
    output reg clk_out
);
    reg [1:0] counter;

    always @(posedge clk_in) begin
        if (enable) begin
            counter <= counter + 1;
            if (counter == 2'b01) begin
                clk_out <= ~clk_out; // Toggle clk_out every 2 input clock cycles
            end
        end
    end

    initial begin
        clk_out = 0;
        counter = 0;
    end
endmodule