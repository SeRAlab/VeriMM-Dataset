module subtractor (
        input [3:0] a,
        input [3:0] b,
        output [3:0] diff,
        output bout);

    wire [4:0] result;

    assign result = {1'b0, a} - {1'b0, b};
    assign diff = result[3:0];
    assign bout = result[4];

endmodule