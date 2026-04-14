module top_module(
    input clk,
    input rst,
    input [1:0] op,
    input [7:0] in,
    output reg [3:0] out
);reg [3:0] a;
reg [3:0] b;
reg [3:0] result;
reg [3:0] temp;

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0000;
    end else begin
        a <= in[3:0];
        b <= in[7:4];
        case (op)
            2'b00: result <= a + b;
            2'b01: result <= a - b;
            2'b10: result <= a * b;
            2'b11: result <= a / b;
        endcase
        out <= result;
    end
end

endmodule