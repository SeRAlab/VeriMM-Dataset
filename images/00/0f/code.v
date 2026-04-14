module divide_by_4 (
    input wire clk,
    input wire [1:0] in,
    output reg [1:0] out
);
    always @(posedge clk) begin
        out <= in / 4;
    end
endmodule