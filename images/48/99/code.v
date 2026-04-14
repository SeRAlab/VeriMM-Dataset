module top_module(
    input clk,
    input rst,
    input [2:0] op,
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] result,
    output reg zero
);always @(posedge clk) begin
    if (rst) begin
        result <= 0;
        zero <= 1;
    end else begin
        case (op)
            3'b000: begin // add
                result <= A + B;
                zero <= (result == 0);
            end
            3'b001: begin // sub
                result <= A - B;
                zero <= (result == 0);
            end
            3'b010: begin // and
                result <= A & B;
                zero <= (result == 0);
            end
            3'b011: begin // or
                result <= A | B;
                zero <= (result == 0);
            end
            3'b100: begin // xor
                result <= A ^ B;
                zero <= (result == 0);
            end
            3'b101: begin // slt
                if (A < B) begin
                    result <= 1;
                    zero <= 0;
                end else begin
                    result <= 0;
                    zero <= 1;
                end
            end
            default: begin
                result <= 0;
                zero <= 1;
            end
        endcase
    end
end

endmodule