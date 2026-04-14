module top_module(
    A,
    B,
    OPCODE,
    RESET,
    RESULT
);input [31:0] A;
    input [31:0] B;
    input [1:0] OPCODE;
    input RESET;
    output [31:0] RESULT;

    reg [31:0] result;

    always @(*) begin
        case(OPCODE)
            2'b00: result = A + B; // addition
            2'b01: result = A - B; // subtraction
            2'b10: result = A * B; // multiplication
            2'b11: result = A / B; // division
            default: result = 0; // default case
        endcase

        if(RESET) begin
            result = 0; // reset result to 0
        end
    end

    assign RESULT = result;

endmodule