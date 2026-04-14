module PLL (
    input wire clk_in,
    input wire reset,
    input wire [1:0] multiplier,
    output reg clk_out
);
    reg [2:0] counter;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == (multiplier * 2 - 1)) begin
                clk_out <= ~clk_out;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule