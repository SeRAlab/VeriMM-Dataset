module top_module(
    input [31:0] a, b,
    input [3:0] aluc,
    output reg [31:0] result
);wire [31:0] addresult;
wire [31:0] subresult;

assign addresult = a + b;
assign subresult = a - b;

always @* begin
    case(aluc)
        4'b0001: result <= a & b; //and
        4'b1001: result <= a & b; //and
        4'b0101: result <= a | b; //or
        4'b1101: result <= a | b; //or
        4'b1010: result <= a ^ b; //xor
        4'b0010: result <= a ^ b; //xor
        4'b0110: result <= {16'b0, b[15:0]}; //lui
        4'b1110: result <= {16'b0, b[15:0]}; //lui
        4'b0000: result <= addresult; //add
        4'b1000: result <= addresult; //add
        4'b0100: result <= subresult; //sub
        4'b1100: result <= subresult; //sub
        4'b0011: result <= b << a; //sll
        4'b0111: result <= b >> a; //srl
        4'b1111: result <= ($signed(b)) >>> a; //sra
        default: result <= addresult; //add
    endcase
end

endmodule