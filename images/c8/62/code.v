module mux4to1_enable (
    input [3:0] in,
    input en,
    output out
);

    assign out = en ? in[0] : 1'b0;
    assign out = en ? in[1] : out;
    assign out = en ? in[2] : out;
    assign out = en ? in[3] : out;

endmodule