module binary_to_bcd (
    input [3:0] binary,
    output reg [7:0] bcd
);

    integer i;

    always @(*) begin
        bcd = 8'b00000000;
        for (i = 0; i < 4; i = i + 1) begin
            if (bcd[3:0] >= 5)
                bcd[3:0] = bcd[3:0] + 3;
            if (bcd[7:4] >= 5)
                bcd[7:4] = bcd[7:4] + 3;
            bcd = {bcd[6:0], binary[3-i]};
        end
    end
endmodule