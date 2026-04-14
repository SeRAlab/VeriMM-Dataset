module bin_to_bcd (bin, bcd_tens, bcd_ones);
   input [3:0] bin;
   output [3:0] bcd_tens;
   output [3:0] bcd_ones;

   reg [3:0] bcd_tens;
   reg [3:0] bcd_ones;

always @(*) begin
    bcd_tens = (bin > 9) ? 1 : 0;
    bcd_ones = (bin > 9) ? (bin - 10) : bin;
end

endmodule