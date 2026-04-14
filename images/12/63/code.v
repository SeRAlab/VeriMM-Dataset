module PLL_2x (
    input wire clk_in,
    input wire enable,
    input wire reset,
    output reg clk_out
);

reg [1:0] counter;

always @(posedge clk_in or posedge reset) begin
    if (reset) begin
        counter <= 2'b00;
        clk_out <= 1'b0;
    end else if (enable) begin
        counter <= counter + 1;
        if (counter == 2'b01) begin
            clk_out <= ~clk_out;
        end
    end
end

endmodule