module top_module(
    input [3:0] reg_a,
    input [3:0] reg_b,
    input [1:0] op,
    input start,
    output reg [3:0] result
);always @ (op or start or reg_a or reg_b)
    begin
        case (op)
            2'b00: result = reg_a + reg_b;
            2'b01: result = reg_a - reg_b;
            2'b10: result = reg_a * reg_b;
            2'b11: result = reg_a / reg_b;
        endcase
    end

endmodule