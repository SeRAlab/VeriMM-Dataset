module top_module(
    input[3:0] count1, 
    input[3:0] count2,
    input[3:0] count3,
    input[3:0] count4,
    output[3:0] sale1,
    output[3:0] sale2,
    output[3:0] sale3,
    output[3:0] sale4
    );assign sale1 = 4'b1100 * count1;
    assign sale2 = 4'b1111 * count2;
    assign sale3 = 4'b0010 * count3;
    assign sale4 = 4'b0011 * count4;
endmodule