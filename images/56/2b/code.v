module top_module(
    input clk,
    input [3:0] keypad_row,
    input [3:0] keypad_col,
    output reg [7:0] keypad_out
);parameter KEY1 = 8'h11, KEY2 = 8'h12, KEY3 = 8'h13, KEY4 = 8'h14,
              KEY5 = 8'h21, KEY6 = 8'h22, KEY7 = 8'h23, KEY8 = 8'h24,
              KEY9 = 8'h31, KEY10 = 8'h32, KEY11 = 8'h33, KEY12 = 8'h34,
              KEY13 = 8'h41, KEY14 = 8'h42, KEY15 = 8'h43, KEY16 = 8'h44;
              
    reg [7:0] keymap [3:0][3:0];
    integer i, j;
    
    always @(*) begin
        case({keypad_row, keypad_col})
            4'b0000: keypad_out = keymap[0][0];
            4'b0001: keypad_out = keymap[0][1];
            4'b0010: keypad_out = keymap[0][2];
            4'b0011: keypad_out = keymap[0][3];
            4'b0100: keypad_out = keymap[1][0];
            4'b0101: keypad_out = keymap[1][1];
            4'b0110: keypad_out = keymap[1][2];
            4'b0111: keypad_out = keymap[1][3];
            4'b1000: keypad_out = keymap[2][0];
            4'b1001: keypad_out = keymap[2][1];
            4'b1010: keypad_out = keymap[2][2];
            4'b1011: keypad_out = keymap[2][3];
            4'b1100: keypad_out = keymap[3][0];
            4'b1101: keypad_out = keymap[3][1];
            4'b1110: keypad_out = keymap[3][2];
            4'b1111: keypad_out = keymap[3][3];
            default: keypad_out = 8'h00;
        endcase
    end
    
    initial begin
        keymap[0][0] = KEY1;
        keymap[0][1] = KEY2;
        keymap[0][2] = KEY3;
        keymap[0][3] = KEY4;
        keymap[1][0] = KEY5;
        keymap[1][1] = KEY6;
        keymap[1][2] = KEY7;
        keymap[1][3] = KEY8;
        keymap[2][0] = KEY9;
        keymap[2][1] = KEY10;
        keymap[2][2] = KEY11;
        keymap[2][3] = KEY12;
        keymap[3][0] = KEY13;
        keymap[3][1] = KEY14;
        keymap[3][2] = KEY15;
        keymap[3][3] = KEY16;
    end
    
endmodule