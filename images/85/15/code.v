module top_module(
    input [31:0] A,
    input [31:0] B,
    input [2:0] OPCODE,
    input CIN,
    output reg COUT,
    output reg [31:0] Y
);always @(*) begin
        case(OPCODE)
            3'b000: Y = A + B + CIN;
            3'b001: Y = A - B - ~CIN;
            3'b010: Y = A & B;
            3'b011: Y = A | B;
            3'b100: Y = A ^ B;
            3'b101: Y = A << B;
            3'b110: Y = A >> B;
            default: Y = 0;
        endcase
        if(OPCODE[1:0] == 2'b00) begin
            COUT = (Y[31] ^ CIN) & (OPCODE[2] ^ Y[30]);
        end else if(OPCODE[1:0] == 2'b01) begin
            COUT = (A[31] ^ B[31] ^ Y[31]) & (A[31] ^ CIN);
        end else begin
            COUT = 0;
        end
    end

endmodule