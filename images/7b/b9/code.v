module top_module(
    input [3:0] ctl,
    input [3:0] a,
    input [3:0] b,
    output reg [3:0] out,
    output zero
);wire [3:0] add_ab;
wire [3:0] sub_ab;
wire [3:0] and_ab;
wire [3:0] or_ab;
wire [3:0] xor_ab;
wire [3:0] not_a;
wire [3:0] shl_a;
wire [3:0] shr_a;
wire ovf;

assign add_ab = a + b;
assign sub_ab = a - b;
assign and_ab = a & b;
assign or_ab = a | b;
assign xor_ab = a ^ b;
assign not_a = ~a;
assign shl_a = {a[2:0], 1'b0};
assign shr_a = {1'b0, a[3:1]};

assign zero = (out == 4'b0000);

assign ovf = (ctl == 4'b0000 || ctl == 4'b0001) ? (a[3] == b[3] && out[3] != a[3]) : 1'b0;

always @(*) begin
    case (ctl)
        4'b0000: out <= add_ab; // Addition
        4'b0001: out <= sub_ab; // Subtraction
        4'b0010: out <= and_ab; // Bitwise AND
        4'b0011: out <= or_ab; // Bitwise OR
        4'b0100: out <= xor_ab; // Bitwise XOR
        4'b0101: out <= not_a; // Bitwise NOT
        4'b0110: out <= shl_a; // Shift left
        4'b0111: out <= shr_a; // Shift right
        default: out <= 4'b0000;
    endcase
end

endmodule