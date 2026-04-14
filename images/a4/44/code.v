module bin_to_bcd_4bit(
    input wire [3:0] bin,
    output reg [7:0] bcd
    );

integer i;

always @(*) begin
    bcd = 8'b0; // Initialize BCD output

    // Shift-and-add-3 algorithm
    for (i = 0; i < 4; i = i + 1) begin
        if (bcd[3:0] > 4) bcd[3:0] = bcd[3:0] + 3;
        if (bcd[7:4] > 4) bcd[7:4] = bcd[7:4] + 3;

        // Shift left by 1 and add the next binary bit
        bcd = {bcd[6:0], bin[3-i]};
    end
end

endmodule