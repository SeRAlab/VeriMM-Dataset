module binary_to_bcd (
    input [3:0] binary,
    output reg [3:0] tens,
    output reg [3:0] ones
);

    integer i;

    always @(*) begin
        // Initialize BCD digits
        tens = 4'b0000;
        ones = 4'b0000;

        // Shift and add-3 algorithm
        for (i = 3; i >= 0; i = i - 1) begin
            if (tens >= 4'b0101)
                tens = tens + 4'b0011;
            if (ones >= 4'b0101)
                ones = ones + 4'b0011;

            tens = tens << 1;
            tens[0] = ones[3];
            ones = ones << 1;
            ones[0] = binary[i];
        end
    end
endmodule