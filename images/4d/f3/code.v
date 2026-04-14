module bin_to_bcd(bin, bcd);
    input [3:0] bin;
    output [7:0] bcd;

    reg [3:0] hundreds;
    reg [3:0] tens;
    reg [3:0] ones;

    always @(*) begin
        // Initialize BCD digits
        hundreds = 4'd0;
        tens = 4'd0;
        ones = bin;

        // Binary to BCD conversion
        if (ones >= 4'd10) begin
            tens = tens + 1;
            ones = ones - 4'd10;
        end
    end

    assign bcd = {hundreds, tens, ones};
endmodule