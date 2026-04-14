module pll_8x (
    input wire clk_in,
    input wire reset,
    output reg clk_out
);
    reg [2:0] count;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            count <= 3'b000;
            clk_out <= 0;
        end else begin
            count <= count + 1;
            if (count == 3'b111) begin
                clk_out <= ~clk_out;
            end
        end
    end
endmodule