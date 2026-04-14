module binary_to_bcd (
  input [3:0] binary,
  output reg [3:0] bcd1,
  output reg [3:0] bcd0
);integer i;
always @* begin
    bcd1 = 4'b0000;
    bcd0 = 4'b0000;
    for (i = 3; i >= 0; i = i - 1) begin
        if (bcd0 >= 4)
            bcd0 = bcd0 + 4;
        if (bcd1 >= 4)
            bcd1 = bcd1 + 4;
        bcd1 = bcd1 << 1;
        bcd1[0] = bcd0[3];
        bcd0 = bcd0 << 1;
        bcd0[0] = binary[i];
    end
end

endmodule