module pll_4x (
    input wire clk_in,      // Input clock
    input wire reset,       // Asynchronous reset
    output reg clk_out      // Output clock (4x)
);
    reg [1:0] counter; // 2-bit counter to divide the input clock

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 2'b00;
            clk_out <= 1'b0;
        end else begin
            counter <= counter + 1;
            if (counter == 2'b11) begin
                clk_out <= ~clk_out; // Toggle output clock every 4 input clock cycles
            end
        end
    end
endmodule