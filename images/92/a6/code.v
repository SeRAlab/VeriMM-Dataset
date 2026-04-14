module top_module(
    select,
    data_0,
    data_1,
    out
);input select;
    input data_0;
    input data_1;
    output out;

    assign out = select ? data_1 : data_0;

endmodule