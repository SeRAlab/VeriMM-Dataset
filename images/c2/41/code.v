module my_inverter (
    Y,
    A
);

    output Y;
    input  A;

    assign Y = ~A;

endmodule