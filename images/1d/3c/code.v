module freq_divider (
    input wire clk,            // Input clock
    input wire enable,         // Enable signal
    input wire [3:0] N,       // 4-bit divider value
    output reg divided_clk     // Divided clock output
);

reg [3:0] count;              // Counter register

always @(posedge clk) begin
    if (enable) begin
        if (count == N) begin
            divided_clk <= ~divided_clk; // Toggle output clock
            count <= 0;                 // Reset counter
        end else begin
            count <= count + 1;         // Increment counter
        end
    end
end

endmodule