module clock_divider (
    input wire clk,       // Input clock
    input wire rst_n,     // Active low reset
    input wire enable,    // Enable signal
    output reg clk_out    // Divided output clock
);
    
    reg [1:0] count;      // 2-bit counter

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            clk_out <= 1'b0;
        end else if (enable) begin
            if (count == 2'b11) begin
                count <= 2'b00;
                clk_out <= ~clk_out; // Toggle output clock
            end else begin
                count <= count + 1'b1; // Increment counter
            end
        end
    end
endmodule