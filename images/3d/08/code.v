module mux16to1 (
    input [15:0] data_in,  // 16 data inputs
    input [3:0] select,    // 4 selection lines
    output reg out         // Output
);
    always @(*) begin
        case (select)
            4'b0000: out = data_in[0];
            4'b0001: out = data_in[1];
            4'b0010: out = data_in[2];
            4'b0011: out = data_in[3];
            4'b0100: out = data_in[4];
            4'b0101: out = data_in[5];
            4'b0110: out = data_in[6];
            4'b0111: out = data_in[7];
            4'b1000: out = data_in[8];
            4'b1001: out = data_in[9];
            4'b1010: out = data_in[10];
            4'b1011: out = data_in[11];
            4'b1100: out = data_in[12];
            4'b1101: out = data_in[13];
            4'b1110: out = data_in[14];
            4'b1111: out = data_in[15];
            default: out = 1'b0; // default case
        endcase
    end
endmodule