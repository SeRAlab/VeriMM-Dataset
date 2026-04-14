module top_module(
    input clk,
    input rst,
    input [1:0] op,
    input [7:0] in1,
    input [7:0] in2,
    output reg [7:0] out,
    output reg valid
);reg [15:0] result;

always @ (posedge clk) begin
    if (rst) begin
        out <= 8'b0;
        valid <= 1'b0;
    end else begin
        case (op)
            2'b00: result <= in1 + in2;
            2'b01: result <= in1 - in2;
            2'b10: result <= in1 * in2;
            2'b11: result <= in1 / in2;
        endcase
        out <= result[7:0];
        valid <= 1'b1;
    end
end

endmodule