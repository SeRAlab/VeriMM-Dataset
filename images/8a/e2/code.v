module top_module(
    input [2:0] ABC,
    input enable,
    output [7:0] Y
);assign Y = (enable == 1'b0) ? {(~ABC[2] & ~ABC[1] & ~ABC[0]), (~ABC[2] & ~ABC[1] & ABC[0]), (~ABC[2] & ABC[1] & ~ABC[0]), (~ABC[2] & ABC[1] & ABC[0]), (ABC[2] & ~ABC[1] & ~ABC[0]), (ABC[2] & ~ABC[1] & ABC[0]), (ABC[2] & ABC[1] & ~ABC[0]), (ABC[2] & ABC[1] & ABC[0])} : 8'b0;

endmodule