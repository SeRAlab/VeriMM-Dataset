module mux32to1 (
    input [31:0] data_in, // 32 input lines
    input [4:0] sel,      // 5 select lines
    output reg out        // 1 output line
);

always @(*) begin
    case (sel)
        5'b00000: out = data_in[0];
        5'b00001: out = data_in[1];
        5'b00010: out = data_in[2];
        5'b00011: out = data_in[3];
        5'b00100: out = data_in[4];
        5'b00101: out = data_in[5];
        5'b00110: out = data_in[6];
        5'b00111: out = data_in[7];
        5'b01000: out = data_in[8];
        5'b01001: out = data_in[9];
        5'b01010: out = data_in[10];
        5'b01011: out = data_in[11];
        5'b01100: out = data_in[12];
        5'b01101: out = data_in[13];
        5'b01110: out = data_in[14];
        5'b01111: out = data_in[15];
        5'b10000: out = data_in[16];
        5'b10001: out = data_in[17];
        5'b10010: out = data_in[18];
        5'b10011: out = data_in[19];
        5'b10100: out = data_in[20];
        5'b10101: out = data_in[21];
        5'b10110: out = data_in[22];
        5'b10111: out = data_in[23];
        5'b11000: out = data_in[24];
        5'b11001: out = data_in[25];
        5'b11010: out = data_in[26];
        5'b11011: out = data_in[27];
        5'b11100: out = data_in[28];
        5'b11101: out = data_in[29];
        5'b11110: out = data_in[30];
        5'b11111: out = data_in[31];
        default: out = 1'b0; // default case
    endcase
end
endmodule