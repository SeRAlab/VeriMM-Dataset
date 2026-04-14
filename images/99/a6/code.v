module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] P
);wire [7:0] temp;

    assign temp = {A[0]&B, A[1]&B, A[2]&B, A[3]&B};

    assign P = temp[0] + temp[1]<<1 + temp[2]<<2 + temp[3]<<3 + temp[4]<<4 + temp[5]<<5 + temp[6]<<6 + temp[7]<<7;

endmodule