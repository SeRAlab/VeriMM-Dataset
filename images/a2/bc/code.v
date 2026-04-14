module down_counter
(
    input clk,
    input sreset,
    input areset,
    output reg [3:0] count
);always @(posedge clk or posedge areset)
    if (areset) begin
        count <= 4'b1111;
    end else if (sreset) begin
        count <= 4'b1111;
    end else begin
        count <= count - 1;
    end
endmodule