module bin_to_bcd (
    input [7:0] bin,
    output reg [11:0] bcd
);integer i;
always @(*) begin
    bcd = 12'b0;
    for (i = 7; i >= 0; i = i - 1) begin
        if (bcd[3:0] >= 5)
            bcd[3:0] = bcd[3:0] + 3;
        if (bcd[7:4] >= 5)
            bcd[7:4] = bcd[7:4] + 3;
        if (bcd[11:8] >= 5)
            bcd[11:8] = bcd[11:8] + 3;
        bcd = {bcd[10:0], bin[i]};
    end
end

endmodule