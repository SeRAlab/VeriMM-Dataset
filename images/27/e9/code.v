module clock_divider (
    input wire clk_in,      // Input clock
    input wire reset,       // Asynchronous reset
    input wire enable,      // Enable signal
    input wire [3:0] factor, // Division factor (1 to 15)
    output reg clk_out      // Output divided clock
);
    reg [3:0] count; // Counter to keep track of clock cycles

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            count <= 0;
            clk_out <= 0;
        end else if (enable) begin
            if (count == (factor - 1)) begin
                clk_out <= ~clk_out; // Toggle output clock
                count <= 0; // Reset count
            end else begin
                count <= count + 1; // Increment count
            end
        end
    end
endmodule