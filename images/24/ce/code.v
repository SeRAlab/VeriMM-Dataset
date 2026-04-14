module pll_8x (
    input wire clk_in,
    input wire rst,
    output reg clk_out
);

    reg [2:0] counter;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            clk_out <= 1'b0;
        end else begin
            counter <= counter + 1;
            if (counter == 3'b111) begin
                clk_out <= ~clk_out; // Toggle output clock every 8 input clock cycles
                counter <= 3'b000; // Reset counter
            end
        end
    end
endmodule