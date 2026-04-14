module binary_counter
(
    input clk,
    input sreset,
    input en,
    output reg [11:0] count
);always @(posedge clk)
    if (sreset) begin
        count <= 12'b0;
    end else if (en) begin
        count <= count + 1;
    end
endmodule