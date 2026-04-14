module five_to_one(
    input [1:0] in1,
    input [2:0] in2,
    input in3,
    input [3:0] in4,
    input [1:0] in5,
    output out1
);

    assign out1 = (in1 >= 2) | (in2 >= 4) | (in3) | ((in4 + in5) >= 5);

endmodule