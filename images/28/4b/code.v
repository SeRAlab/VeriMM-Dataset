module PLL_8x (
    input wire clk_in,
    input wire reset,
    output reg clk_out
);
    reg [2:0] counter; // 3-bit counter to divide by 8

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == 7) begin
                counter <= 0;
                clk_out <= ~clk_out; // Toggle output clock
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule