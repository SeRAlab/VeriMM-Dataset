module top_module(
    input [7:0] D,
    output [2:0] EN
);assign EN = (D[7]) ? 3'b100 :
                (D[6]) ? 3'b010 :
                (D[5]) ? 3'b001 :
                (D[7:6]) ? 3'b110 :
                (D[7:5]) ? 3'b101 :
                (D[6:5]) ? 3'b011 :
                (D[7:5]) ? 3'b111 :
                3'b000;

endmodule