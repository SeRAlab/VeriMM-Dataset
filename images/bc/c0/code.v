module BinToBCD (
    input [11:0] binary,
    output reg [15:0] bcd
);
    integer i;
    always @(*) begin
        bcd = 16'd0;
        for (i = 11; i >= 0; i = i - 1) begin
            bcd = {bcd[14:0], binary[i]};
            if (bcd[3:0] > 4)
                bcd[3:0] = bcd[3:0] + 3;
            if (bcd[7:4] > 4)
                bcd[7:4] = bcd[7:4] + 3;
            if (bcd[11:8] > 4)
                bcd[11:8] = bcd[11:8] + 3;
            if (bcd[15:12] > 4)
                bcd[15:12] = bcd[15:12] + 3;
        end
    end
endmodule