module top_module(
    input [7:0] A,
    input [7:0] B,
    input [2:0] control,
    output reg [7:0] result
);always @(*) begin
        case (control)
            3'b000: result = A + B;
            3'b001: result = A - B;
            3'b010: result = A & B;
            3'b011: result = A | B;
            3'b100: result = A ^ B;
            3'b101: result = A << B;
            3'b110: result = A >> B;
            3'b111: result = A * B;
            default: result = 8'h00;
        endcase
    end

endmodule