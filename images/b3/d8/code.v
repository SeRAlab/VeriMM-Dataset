module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] Sum,
    output reg Cout
);reg [3:0] Temp;
    reg Carry;

    always @ (A or B or Carry) begin
        Temp = A ^ B ^ Carry;
        Cout = (A & B) | (Carry & (A ^ B));
        Carry = (A & B) | (Carry & (A ^ B));
        Sum = Temp;
    end

endmodule