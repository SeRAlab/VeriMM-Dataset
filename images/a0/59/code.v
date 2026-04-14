module top_module(
    input enable,
    input [3:0] select,  // Change the size of select to 4 bits
    output [15:0] out
);assign out[0] = (enable && (select == 4'b0000)) ? 1'b1 : 1'b0;
    assign out[1] = (enable && (select == 4'b0001)) ? 1'b1 : 1'b0;
    assign out[2] = (enable && (select == 4'b0010)) ? 1'b1 : 1'b0;
    assign out[3] = (enable && (select == 4'b0011)) ? 1'b1 : 1'b0;
    assign out[4] = (enable && (select == 4'b0100)) ? 1'b1 : 1'b0;
    assign out[5] = (enable && (select == 4'b0101)) ? 1'b1 : 1'b0;
    assign out[6] = (enable && (select == 4'b0110)) ? 1'b1 : 1'b0;
    assign out[7] = (enable && (select == 4'b0111)) ? 1'b1 : 1'b0;
    assign out[8] = (enable && (select == 4'b1000)) ? 1'b1 : 1'b0;
    assign out[9] = (enable && (select == 4'b1001)) ? 1'b1 : 1'b0;
    assign out[10] = (enable && (select == 4'b1010)) ? 1'b1 : 1'b0;
    assign out[11] = (enable && (select == 4'b1011)) ? 1'b1 : 1'b0;
    assign out[12] = (enable && (select == 4'b1100)) ? 1'b1 : 1'b0;
    assign out[13] = (enable && (select == 4'b1101)) ? 1'b1 : 1'b0;
    assign out[14] = (enable && (select == 4'b1110)) ? 1'b1 : 1'b0;
    assign out[15] = (enable && (select == 4'b1111)) ? 1'b1 : 1'b0;

endmodule