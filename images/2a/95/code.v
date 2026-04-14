module PLL_4x (
    input wire clk_in,
    input wire reset,
    output reg clk_out,
    output reg clk_div
);

reg [1:0] counter;

always @(posedge clk_in or posedge reset) begin
    if (reset) begin
        counter <= 2'b00;
        clk_out <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        counter <= counter + 1;
        if (counter == 2'b11) begin
            clk_out <= ~clk_out; // Toggle clk_out every 4 input clocks
        end
        if (counter[1] == 1'b1) begin
            clk_div <= ~clk_div; // Toggle clk_div every 2 output clocks
        end
    end
end

endmodule