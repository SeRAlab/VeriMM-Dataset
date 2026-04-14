module divide_by_4 (
    input wire clk,
    input wire [7:0] in,
    output reg [7:0] out
);
    always @(posedge clk) begin
        out <= in >> 2;
    end
endmodule