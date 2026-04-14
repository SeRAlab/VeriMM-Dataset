module top_module(
    nextCount,
    count
);output [7:0] nextCount;
wire [7:0] nextCount;
input [7:0] count;







assign nextCount = (count + 1) % 256;

endmodule