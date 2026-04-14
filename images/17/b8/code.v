module mux16to1 (
    input [15:0] I, // 16 inputs
    input [3:0] S,  // 4 selection lines
    output reg Y    // Output
);
    always @(*) begin
        case(S)
            4'b0000: Y = I[0];
            4'b0001: Y = I[1];
            4'b0010: Y = I[2];
            4'b0011: Y = I[3];
            4'b0100: Y = I[4];
            4'b0101: Y = I[5];
            4'b0110: Y = I[6];
            4'b0111: Y = I[7];
            4'b1000: Y = I[8];
            4'b1001: Y = I[9];
            4'b1010: Y = I[10];
            4'b1011: Y = I[11];
            4'b1100: Y = I[12];
            4'b1101: Y = I[13];
            4'b1110: Y = I[14];
            4'b1111: Y = I[15];
            default: Y = 1'b0; // Default case
        endcase
    end
endmodule