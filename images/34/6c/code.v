module clock_divider (
    input wire clk_in,       // Input clock
    input wire enable,       // Enable signal
    output reg clk_out       // Output divided clock
);
    reg [1:0] counter;

    always @(posedge clk_in) begin
        if (enable) begin
            counter <= counter + 1;
            if (counter == 2'b01) begin
                clk_out <= ~clk_out; // Toggle clock output
            end
        end
    end

    initial begin
        clk_out = 0;
        counter = 0;
    end
endmodule