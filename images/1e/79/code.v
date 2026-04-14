module divide_by_8 (
    input clk,
    input [7:0] in,
    output reg [4:0] out
);
    always @(posedge clk) begin
        out <= in / 8;
    end
endmodule