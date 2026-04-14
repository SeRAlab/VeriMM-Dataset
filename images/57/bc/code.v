module top_module(MO,
              A,
              B,
              S);input A, B, S;
    output MO;

    assign MO = (S == 1) ? B : A;

endmodule