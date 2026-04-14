module decoder_2to4 (
    input wire [1:0] a,
    output wire [3:0] y
);

    assign y = (a == 2'b00) ? 4'b0001 :
               (a == 2'b01) ? 4'b0010 :
               (a == 2'b10) ? 4'b0100 :
               (a == 2'b11) ? 4'b1000 :
               4'b0000;

endmodule