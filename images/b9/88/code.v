module down_counter_with_enable
(
    input clk,
    input en,
    input sreset,
    input areset,
    output reg [15:0] count
);always @(posedge clk or posedge areset)
    if (areset) begin
        count <= 16'b1111111111111111;
    end else if (sreset) begin
        count <= 16'b1111111111111111;
    end else if (en) begin
        count <= count - 1;
    end
endmodule