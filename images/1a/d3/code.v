module pll_8x (
    input wire clk_in,
    input wire reset,
    output reg clk_out
);
    reg [2:0] counter;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            clk_out <= 0;
            counter <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 3'b111) begin
                clk_out <= ~clk_out; // Toggle the output clock
            end
        end
    end
endmodule