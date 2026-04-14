module my_module(input A, B, C, D, output out);
    wire temp;
    assign temp = (B == 1) ? A : C;
    assign out = (D == 1) ? ~temp : temp;
endmodule