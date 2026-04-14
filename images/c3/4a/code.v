module clk_divider(
    input clk,
    output reg slower_clk
);

reg [24:0] counter;

always @(posedge clk) begin
    counter <= counter + 1;
    if (counter == 1250000) begin
        slower_clk <= ~slower_clk;
        counter <= 0;
    end
end

endmodule