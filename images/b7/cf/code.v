module top_module(
    input in1,
    input in2,
    input in3,
    input in4,
    output out1
);wire w1, w2, w3, w4, w5, w6, w7;

    // Calculate the majority vote
    assign w1 = ~(in1 & in2);
    assign w2 = ~(in1 & in3);
    assign w3 = ~(in1 & in4);
    assign w4 = ~(in2 & in3);
    assign w5 = ~(in2 & in4);
    assign w6 = ~(in3 & in4);
    assign w7 = ~(w1 & w2 & w3 & w4 & w5 & w6);

    // Calculate the output
    assign out1 = (in1 & in2 & in3 & in4) | w7;

endmodule