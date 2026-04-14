module Ch_function (
    input wire clk,
    input wire [31:0] x,
    input wire [31:0] y,
    input wire [31:0] z,
    output reg [31:0] out
);
    always @(posedge clk) begin
        out <= (x & y) ^ (~x & z);
    end
endmodule