module pll_8x (
    input wire clk_in,
    input wire reset,
    output reg clk_out
);
    reg [2:0] count; // 3-bit counter

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            count <= 3'b000; // Reset counter
            clk_out <= 0; // Reset output clock
        end else begin
            if (count == 3'b111) begin
                clk_out <= ~clk_out; // Toggle output clock
                count <= 3'b000; // Reset counter
            end else begin
                count <= count + 1; // Increment counter
            end
        end
    end
endmodule