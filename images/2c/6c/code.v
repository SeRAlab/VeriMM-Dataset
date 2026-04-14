module pll_2x(
    input wire clk_ref,      // Reference clock input
    input wire enable,       // Enable signal
    output reg clk_out       // Output clock at 2x frequency
);
    reg [1:0] counter;       // 2-bit counter to divide by 2

    always @(posedge clk_ref) begin
        if (enable) begin
            counter <= counter + 1;
            if (counter == 2'b01) begin
                clk_out <= ~clk_out; // Toggle output clock
            end
        end
    end

    // Initialize clk_out
    initial begin
        clk_out = 0;
        counter = 0;
    end
endmodule