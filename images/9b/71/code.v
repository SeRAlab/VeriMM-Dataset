module binary_decoder (
    input [1:0] in,
    output [3:0] out
);

    // 2-bit binary decoder logic
    assign out = (in == 2'b00) ? 4'b0001 :
                 (in == 2'b01) ? 4'b0010 :
                 (in == 2'b10) ? 4'b0100 :
                                 4'b1000;

endmodule