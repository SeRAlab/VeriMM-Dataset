module top_module(A, B, valid);input A, B;
    output valid;
    assign valid = A & (~B);
endmodule