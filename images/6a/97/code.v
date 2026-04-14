module top_module(
    A,
    B,
    OP,
    Y
);// Module ports
    input A;
    input B;
    input [1:0] OP;
    output reg Y;  // Change output Y to reg

    // Module logic
    wire and_out;
    wire or_out;
    wire xor_out;
    wire not_out;

    assign and_out = A & B;
    assign or_out = A | B;
    assign xor_out = A ^ B;
    assign not_out = ~A;

    always @(*) begin
        case (OP)
            2'b00: Y = and_out;
            2'b01: Y = or_out;
            2'b10: Y = xor_out;
            2'b11: Y = not_out;
            default: Y = 1'b0;  // Handle default case
        endcase
    end

endmodule