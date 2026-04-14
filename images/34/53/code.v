module pll_8x (
    input wire clk_in,      // Input clock
    input wire reset,       // Asynchronous reset
    output reg clk_out      // Output clock
);

    reg [2:0] counter;      // 3-bit counter to count up to 8

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 3'b0;
            clk_out <= 1'b0;
        end else begin
            counter <= counter + 1;
            if (counter == 3'b111) begin
                clk_out <= ~clk_out; // Toggle output clock every 8 input clock cycles
                counter <= 3'b0;
            end
        end
    end

endmodule