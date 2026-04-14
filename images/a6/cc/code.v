module top_module(input[1:0] rot, output reg[0:15] block);wire[0:15] z0 = 16'b1100011000000000;
wire[0:15] z1 = 16'b0010011001000000;
wire[0:15] z2 = 16'b0000110001100000;
wire[0:15] z3 = 16'b0100110010000000;

always @*
begin
    case(rot)
        0: block = z0;
        1: block = z1;
        2: block = z2;
        3: block = z3;
        default: block = z0;
    endcase
end

endmodule