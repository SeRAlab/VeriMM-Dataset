module top_module(
    input [511:0] A,
    output [63:0] B
);reg [7:0] B_temp [0:63];
    integer i, j;

    always @(*) begin
        for (i = 0; i < 64; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                B_temp[i][j] = A[i*8 + j];
            end
        end
    end

    assign B = {B_temp[0], B_temp[1], B_temp[2], B_temp[3], B_temp[4], B_temp[5], B_temp[6], B_temp[7],
                B_temp[8], B_temp[9], B_temp[10], B_temp[11], B_temp[12], B_temp[13], B_temp[14], B_temp[15],
                B_temp[16], B_temp[17], B_temp[18], B_temp[19], B_temp[20], B_temp[21], B_temp[22], B_temp[23],
                B_temp[24], B_temp[25], B_temp[26], B_temp[27], B_temp[28], B_temp[29], B_temp[30], B_temp[31],
                B_temp[32], B_temp[33], B_temp[34], B_temp[35], B_temp[36], B_temp[37], B_temp[38], B_temp[39],
                B_temp[40], B_temp[41], B_temp[42], B_temp[43], B_temp[44], B_temp[45], B_temp[46], B_temp[47],
                B_temp[48], B_temp[49], B_temp[50], B_temp[51], B_temp[52], B_temp[53], B_temp[54], B_temp[55],
                B_temp[56], B_temp[57], B_temp[58], B_temp[59], B_temp[60], B_temp[61], B_temp[62], B_temp[63]};

endmodule