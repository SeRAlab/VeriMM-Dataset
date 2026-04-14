module top_module(Columns, Rows, KeyNumber);input [3:0] Columns;
    input [3:0] Rows;
    output reg [4:0] KeyNumber;

    parameter NoKey = 5'b00000;
    parameter key1 = 5'b00001;
    parameter key2 = 5'b00010;
    parameter key3 = 5'b00011;
    parameter key4 = 5'b00100;
    parameter key5 = 5'b00101;
    parameter key6 = 5'b00110;
    parameter key7 = 5'b00111;
    parameter key8 = 5'b01000;
    parameter key9 = 5'b01001;
    parameter keyA = 5'b01010;
    parameter keyB = 5'b01011;
    parameter keyC = 5'b01100;
    parameter keyD = 5'b01101;
    parameter keyStar = 5'b01110;
    parameter key0 = 5'b01111;
    parameter keyPound = 5'b10000;

    always @ (Columns or Rows) begin
        case ({Columns, Rows})
            8'b01110111: KeyNumber <= key1;
            8'b10110111: KeyNumber <= key2;
            8'b11010111: KeyNumber <= key3;
            8'b01111011: KeyNumber <= key4;
            8'b10111011: KeyNumber <= key5;
            8'b11011011: KeyNumber <= key6;
            8'b01111101: KeyNumber <= key7;
            8'b10111101: KeyNumber <= key8;
            8'b11011101: KeyNumber <= key9;
            8'b11100111: KeyNumber <= keyA;
            8'b11101011: KeyNumber <= keyB;
            8'b11101101: KeyNumber <= keyC;
            8'b11101110: KeyNumber <= keyD;
            8'b01111110: KeyNumber <= keyStar;
            8'b10111110: KeyNumber <= key0;
            8'b11011110: KeyNumber <= keyPound;
            default: KeyNumber <= NoKey;
        endcase
    end
endmodule