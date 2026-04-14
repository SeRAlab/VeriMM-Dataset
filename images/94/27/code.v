module top_module(
    out,
    a,
    b,
    c,
    d,
    e,
    f,
    g,
    h
);output out;
    input a;
    input b;
    input c;
    input d;
    input e;
    input f;
    input g;
    input h;

    wire temp1;
    wire temp2;
    wire temp3;
    wire temp4;
    wire temp5;
    wire temp6;
    wire temp7;

    assign temp1 = ~a;
    assign temp2 = (temp1 & b);
    assign temp3 = (temp2 | c);
    assign temp4 = (temp3 & ~d);
    assign temp5 = (temp4 | e);
    assign temp6 = (temp5 & ~f);
    assign temp7 = (temp6 | g);

    assign out = (temp7 & ~h);

endmodule