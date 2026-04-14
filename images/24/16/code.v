module PLL_4x (
    input wire clk_in,
    input wire reset,
    output reg clk_out
);
    reg [1:0] count;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            clk_out <= 0;
            count <= 0;
        end else begin
            count <= count + 1;
            if (count == 3) begin
                clk_out <= ~clk_out; // toggle every 4 input clock cycles
                count <= 0;
            end
        end
    end
endmodule