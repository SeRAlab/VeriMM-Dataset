module alu_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [2:0] op,
    output wire [15:0] y,
    output wire zero
);

    wire zero_temp;
    wire [3:0] y0, y1, y2, y3;

    alu_4bit alu_4bit_inst1 (
        .a(a[15:12]),
        .b(b[15:12]),
        .op(op),
        .y(y[15:12]),
        .zero(zero_temp)
    );

    alu_4bit alu_4bit_inst2 (
        .a(a[11:8]),
        .b(b[11:8]),
        .op(op),
        .y(y[11:8]),
        .zero(zero_temp)
    );

    alu_4bit alu_4bit_inst3 (
        .a(a[7:4]),
        .b(b[7:4]),
        .op(op),
        .y(y[7:4]),
        .zero(zero_temp)
    );

    alu_4bit alu_4bit_inst4 (
        .a(a[3:0]),
        .b(b[3:0]),
        .op(op),
        .y(y[3:0]),
        .zero(zero_temp)
    );

    assign zero = ~(y[15] | y[14] | y[13] | y[12] | y[11] | y[10] | y[9] | y[8] | y[7] | y[6] | y[5] | y[4] | y[3] | y[2] | y[1] | y[0]);

endmodule

module alu_4bit (
    input wire [3:0] a,
    input wire [3:0] b,
    input wire [2:0] op,
    output wire [3:0] y,
    output wire zero
);

    wire zero_temp;
    wire [1:0] y0, y1;

    alu_2bit alu_2bit_inst1 (
        .a(a[3:2]),
        .b(b[3:2]),
        .op(op),
        .y(y[3:2]),
        .zero(zero_temp)
    );

    alu_2bit alu_2bit_inst2 (
        .a(a[1:0]),
        .b(b[1:0]),
        .op(op),
        .y(y[1:0]),
        .zero(zero_temp)
    );

    assign zero = ~(y[3] | y[2] | y[1] | y[0]);

endmodule

module alu_2bit (
    input wire [1:0] a,
    input wire [1:0] b,
    input wire [2:0] op,
    output wire [1:0] y,
    output wire zero
);

    always @(*) begin
        case (op)
            3'b000: y = a + b;   // Addition
            3'b001: y = a - b;   // Subtraction
            3'b010: y = a & b;   // AND
            3'b011: y = a | b;   // OR
            3'b100: y = a ^ b;   // XOR
            3'b101: y = ~a;      // NOT
            3'b110: y = a << 1;  // Shift left
            3'b111: y = a >> 1;  // Shift right
            default: y = 2'b00;
        endcase
    end

    assign zero = ~(y[1] | y[0]);

endmodule