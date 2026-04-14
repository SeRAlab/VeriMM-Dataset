module top_module(
input [31:0]gravity0,
input [31:0]gravity1,
output fall
    );parameter [31:0]value = 700;
    assign fall = (gravity0 > gravity1) ? (((gravity0 - gravity1) > value) ? 1'b1 : 1'b0) : 1'b0;
endmodule