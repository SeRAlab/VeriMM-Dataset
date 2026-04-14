module down_counter_with_reset
(
    input clk,
    input en,
    input sreset,
    output reg [4:0] count
);always @(posedge clk)
    if (sreset) begin
        count <= 5'b11111;
    end else if (en) begin
        count <= count - 1;
    end
endmodule