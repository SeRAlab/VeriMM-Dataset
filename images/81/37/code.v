module top_module(A, B, sum, c_out);input A, B;
    output sum, c_out;

    assign sum = A^B;
    assign c_out = A&B;endmodule