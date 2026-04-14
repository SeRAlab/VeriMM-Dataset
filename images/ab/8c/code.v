module top_module(
    input [7:0] A,
    input [7:0] B,
    input [1:0] opcode,
    input en,
    output reg [7:0] R
);always @(*) begin
    if (en == 1) begin
        case(opcode)
            2'b00: R = A + B; // addition
            2'b01: R = A - B; // subtraction
            2'b10: R = A * B; // multiplication
            2'b11: R = A / B; // division
        endcase
    end else begin
        R = 8'b0;
    end
end

endmodule