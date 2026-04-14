module top_module(
    input [7:0] op1,
    input [7:0] op2,
    input [1:0] op_sel,
    output reg [7:0] sum,
    output reg [7:0] diff,
    output reg [7:0] product,
    output reg [7:0] quotient
);always @(*) begin
    case(op_sel)
        2'b00: begin // addition
            sum = op1 + op2;
            diff = 8'h00;
            product = 8'h00;
            quotient = 8'h00;
        end
        2'b01: begin // subtraction
            sum = 8'h00;
            diff = op1 - op2;
            product = 8'h00;
            quotient = 8'h00;
        end
        2'b10: begin // multiplication
            sum = 8'h00;
            diff = 8'h00;
            product = op1 * op2;
            quotient = 8'h00;
        end
        2'b11: begin // division
            sum = 8'h00;
            diff = 8'h00;
            product = 8'h00;
            quotient = op1 / op2;
        end
    endcase
end

endmodule