module alu16bit (
    input wire [15:0] A,
    input wire [15:0] B,
    input wire [1:0] ctrl,
    output reg [15:0] result
);

    always @(*) begin
        case (ctrl)
            2'b00: result = A + B; // ADD
            2'b01: result = A - B; // SUB
            2'b10: result = A & B; // AND
            2'b11: result = A | B; // OR
            default: result = 16'b0;
        endcase
    end

endmodule