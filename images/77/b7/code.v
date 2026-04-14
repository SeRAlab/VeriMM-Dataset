module top_module(
    input wire [15:0] in,
    input wire [3:0] shift_amt,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);// 16-bit barrel shifter
    reg [15:0] shifted_in;
    always @(*) begin
        shifted_in = (shift_amt == 0) ? in :
                     (shift_amt == 1) ? {in[14:0], 1'b0} :
                     (shift_amt == 2) ? {in[13:0], 2'b00} :
                     (shift_amt == 3) ? {in[12:0], 3'b000} :
                     (shift_amt == 4) ? {in[11:0], 4'b0000} :
                     (shift_amt == 5) ? {in[10:0], 5'b00000} :
                     (shift_amt == 6) ? {in[9:0], 6'b000000} :
                     (shift_amt == 7) ? {in[8:0], 7'b0000000} :
                     (shift_amt == 8) ? {in[7:0], 8'b00000000} :
                     (shift_amt == 9) ? {in[6:0], 9'b000000000} :
                     (shift_amt == 10) ? {in[5:0], 10'b0000000000} :
                     (shift_amt == 11) ? {in[4:0], 11'b00000000000} :
                     (shift_amt == 12) ? {in[3:0], 12'b000000000000} :
                     (shift_amt == 13) ? {in[2:0], 13'b0000000000000} :
                     (shift_amt == 14) ? {in[1:0], 14'b00000000000000} :
                     {in[0], 15'b000000000000000};
    end

    // Separate 16-bit input into two 8-bit outputs
    assign out_hi = shifted_in[15:8];
    assign out_lo = shifted_in[7:0];

endmodule