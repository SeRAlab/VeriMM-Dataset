module top_module(A, B, c_in, sum, c_out);input A, B, c_in;
    output sum, c_out;

    assign sum = A^B^c_in;
    assign c_out = (A&B)|((A^B)&c_in);endmodule