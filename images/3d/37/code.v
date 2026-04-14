module pll (
    input wire clk_in,
    input wire enable,
    output reg clk_out
);
    reg [1:0] counter; // 2-bit counter to create a frequency multiplier
    always @(posedge clk_in) begin
        if (enable) begin
            counter <= counter + 1;
            if (counter == 2'b11) begin // Toggle output clock every 4 input clocks
                clk_out <= ~clk_out;
                counter <= 0;
            end
        end
    end
endmodule