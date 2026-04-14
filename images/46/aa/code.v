module top_module(
    input [2:0] sel,
    input [3:0] data,
    output w,x,y,z);assign w = (sel == 3'b000) ? data[0] : 1'b0;
    assign x = (sel == 3'b001) ? data[1] : 1'b0;
    assign y = (sel == 3'b010) ? data[2] : 1'b0;
    assign z = (sel == 3'b011) ? data[3] : 1'b0;

endmodule