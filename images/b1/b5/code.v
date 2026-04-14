module top_module(
    input clk,
    input rst,
    input [1:0] op,
    input [7:0] in1,
    input [7:0] in2,
    input clr,
    output reg [7:0] out
);reg [7:0] result;

always @(posedge clk) begin
    if (rst) begin
        result <= 0;
    end else if (clr) begin
        result <= 0;
    end else begin
        case (op)
            2'b00: result <= in1 + in2;
            2'b01: result <= in1 - in2;
            2'b10: result <= in1 * in2;
            2'b11: result <= in1 / in2;
        endcase
    end
end

assign out = result;

endmodule