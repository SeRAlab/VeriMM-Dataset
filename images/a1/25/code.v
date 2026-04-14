module top_module(input[1:0] rot, output reg[0:15] block);wire[0:15] l0 = 16'b0100010011000000;
wire[0:15] l1 = 16'b0000111010000000;
wire[0:15] l2 = 16'b1100010001000000;
wire[0:15] l3 = 16'b0010111000000000;

always @*
begin
    case(rot)
        0: block = l0;
        1: block = l1;
        2: block = l2;
        3: block = l3;
        default: block = l0;
    endcase
end

endmodule