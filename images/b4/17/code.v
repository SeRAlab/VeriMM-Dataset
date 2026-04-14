module top_module(
    input wire [2:0] in_vec,
    output wire [2:0] out_vec,
    output wire o2,
    output wire o1,
    output wire o0,
    input a, b, cin,
    output cout,
    output sum,
    output wire [4:0] final_output
);// Binary splitter module
    assign out_vec = in_vec;
    assign o2 = in_vec[2];
    assign o1 = in_vec[1];
    assign o0 = in_vec[0];

    // Full adder module
    wire w1, w2, w3;
    assign w1 = a ^ b;
    assign w2 = w1 ^ cin;
    assign sum = w2;
    assign w3 = (a & b) | (cin & w1);
    assign cout = w3;

    // Functional module
    wire and_out, or_out;
    assign and_out = o2 & o1;
    assign or_out = o2 | o1;
    assign final_output[4] = and_out;
    assign final_output[3] = and_out;
    assign final_output[2] = or_out;
    assign final_output[1] = or_out;
    assign final_output[0] = sum;

endmodule