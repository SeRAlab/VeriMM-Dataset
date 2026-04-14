module top_module(in, out);input  wire [7:0] in;
    output wire [7:0] out;

    assign out = in + 2;

endmodule