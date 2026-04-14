module bin_to_bcd(
    input [3:0] bin,

    output [7:0] bcd
);

assign bcd = (bin > 4'd9) ? 8'b00010010 : {4'b0000, bin};

endmodule