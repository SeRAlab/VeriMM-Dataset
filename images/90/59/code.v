module ALU (
    input [31:0] a,
    input [31:0] b,
    input [1:0] control,
    output reg [31:0] result
);
    always @(*) begin
        case (control)
            2'b00: result = a + b;
            2'b01: result = a - b;
            2'b10: result = a & b;
            2'b11: result = a | b;
            default: result = 32'b0;
        endcase
    end
endmodule