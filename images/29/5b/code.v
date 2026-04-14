module pll_4x(
    input clk_ref,
    input reset,
    output reg clk_out
);
    reg [1:0] counter;

    always @(posedge clk_ref or posedge reset) begin
        if (reset) begin
            counter <= 2'b00;
            clk_out <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 2'b11) begin
                clk_out <= ~clk_out;
            end
        end
    end
endmodule