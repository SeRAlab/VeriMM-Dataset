module rrt_midpoint (
    input [4:0] x1,
    input [4:0] y1,
    input [4:0] x2,
    input [4:0] y2,
    output [9:0] midpoint
);
    assign midpoint = {((x1 + x2) >> 1), ((y1 + y2) >> 1)};
endmodule