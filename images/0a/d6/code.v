module pll_8x (
    input clk_in,
    input reset,
    output reg clk_out
);
    reg [2:0] counter;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 3'b000;
            clk_out <= 0;
        end else begin
            if (counter == 3'b111) begin
                clk_out <= ~clk_out; // Toggle output clock
                counter <= 3'b000; // Reset counter
            end else begin
                counter <= counter + 1; // Increment counter
            end
        end
    end
endmodule