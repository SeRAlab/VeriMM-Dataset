module pll_2x (
    input wire clk_in,
    input wire rst,
    output reg clk_out
);

reg [1:0] counter;

always @(posedge clk_in or posedge rst) begin
    if (rst) begin
        clk_out <= 0;
        counter <= 0;
    end else begin
        counter <= counter + 1;
        if (counter == 1) begin
            clk_out <= ~clk_out; // Toggle output clock every 2 input clock cycles
        end
    end
end

endmodule