module top_module(inputbin, displayout);input [3:0] inputbin;
output [6:0] displayout;

parameter bit0 = 7'b0000001;
parameter bit1 = 7'b0000010;
parameter bit2 = 7'b0000100;
parameter bit3 = 7'b0001000;
parameter bit4 = 7'b0010000;
parameter bit5 = 7'b0100000;
parameter bit6 = 7'b1000000;

parameter zero  = ~(bit0 | bit1 | bit2 | bit3 | bit4 | bit5);
parameter one   = ~(bit1 | bit2);
parameter two   = ~(bit0 | bit1 | bit3 | bit4 | bit6);
parameter three = ~(bit0 | bit1 | bit2 | bit3 | bit6);
parameter four  = ~(bit1 | bit2 | bit5 | bit6);
parameter five  = ~(bit0 | bit2 | bit3 | bit5 | bit6);
parameter six   = ~(bit0 | bit2 | bit3 | bit4 | bit5 | bit6);
parameter seven = ~(bit0 | bit1 | bit2);
parameter eight = ~(bit0 | bit1 | bit2 | bit3 | bit4 | bit5 | bit6);
parameter nine  = ~(bit0 | bit1 | bit2 | bit5 | bit6);
parameter blank = ~(7'd0);

reg [6:0] displayout;

always @ (inputbin)
begin
    case (inputbin)
        4'd0: displayout = zero;
        4'd1: displayout = one;
        4'd2: displayout = two;
        4'd3: displayout = three;
        4'd4: displayout = four;
        4'd5: displayout = five;
        4'd6: displayout = six;
        4'd7: displayout = seven;
        4'd8: displayout = eight;
        4'd9: displayout = nine;
        4'd10: displayout = 7'b0111111; // A
        4'd11: displayout = 7'b0001111; // b
        4'd12: displayout = 7'b0100111; // C
        4'd13: displayout = 7'b0011110; // d
        4'd14: displayout = 7'b0100111; // E
        4'd15: displayout = 7'b0100011; // F
        default: displayout = blank;
    endcase
end

endmodule