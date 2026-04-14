module PLL_8x (
    input wire clk_in,
    input wire rst,
    input wire enable,
    output reg clk_out,
    output reg clk_out_div2
);
    reg [2:0] counter;
    parameter DIVISOR = 8;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            clk_out <= 1'b0;
            clk_out_div2 <= 1'b0;
        end else if (enable) begin
            if (counter == DIVISOR - 1) begin
                clk_out <= ~clk_out;
                counter <= 3'b000;
            end else begin
                counter <= counter + 1;
            end
            clk_out_div2 <= clk_out; // divide by 2 for verification
        end
    end
endmodule