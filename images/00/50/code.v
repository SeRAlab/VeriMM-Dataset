module pll_4x (
    input wire clk_in,
    input wire reset,
    output reg clk_out,
    output reg locked
);
    reg [1:0] clk_div; // 2-bit divider
    reg [3:0] counter; // 4-bit counter for locking

    // State machine for locked status and frequency multiplication
    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            clk_div <= 2'b00;
            counter <= 4'b0000;
            clk_out <= 0;
            locked <= 0;
        end else begin
            // Generate 4x clock
            clk_div <= clk_div + 1;
            if (clk_div == 2'b11) begin
                clk_out <= ~clk_out; // Toggle output clock every 4 input clocks
            end
            
            // Lock detection logic
            if (counter < 4'b1111) begin
                counter <= counter + 1;
            end else begin
                locked <= 1; // Set locked when counter reaches threshold
            end
        end
    end
endmodule