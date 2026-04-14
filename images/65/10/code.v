module top_module(input[1:0] rot, output reg[0:15] block);wire[0:15] j0 = 16'b0100010011000000;
wire[0:15] j1 = 16'b1000111000000000;
wire[0:15] j2 = 16'b0110010001000000;
wire[0:15] j3 = 16'b0000111000100000;

always @*
begin
    case(rot)
        0: block = j0;
        1: block = j1;
        2: block = j2;
        3: block = j3;
        default: block = j0;
    endcase
end

endmodule