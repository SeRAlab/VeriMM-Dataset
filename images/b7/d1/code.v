module top_module(
    input [3:0] A,
    input [3:0] B,
    input [2:0] control,
    output reg [3:0] result
);always @(*) begin
        case (control)
            3'b000: result = A + B;
            3'b001: result = A - B;
            3'b010: result = A & B;
            3'b011: result = A | B;
            default: result = 4'b0000;
        endcase
    end

endmodule