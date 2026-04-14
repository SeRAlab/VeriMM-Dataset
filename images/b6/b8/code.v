module top_module(
        input [7:0] binary,
        output [31:0] bcd_out
);reg [3:0] hundreds;
    reg [3:0] tens;
    reg [3:0] ones;

    integer i;

    assign bcd_out = (binary == 8'b0) ? 32'b1 : {12'b0, hundreds, 4'b0, tens, 4'b0, ones};

    always @ (binary) begin
        hundreds = 4'd0;
        tens = 4'd0;
        ones = 4'd0;
        for (i = 7; i >= 0; i = i - 1) begin
            if (hundreds >= 5) begin
                hundreds = hundreds + 3;
            end
            if (tens >= 5) begin
                tens = tens + 3;
            end
            if (ones >= 5) begin
                ones = ones + 3;
            end

            hundreds = hundreds << 1;
            hundreds[0] = tens[3];
            tens = tens << 1;
            tens[0] = ones[3];
            ones = ones << 1;
            ones[0] = binary[i];
        end
    end

endmodule