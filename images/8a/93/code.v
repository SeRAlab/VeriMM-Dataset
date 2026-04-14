module top_module(
    sel,
    data_in_0,
    data_in_1,
    out
);// Module ports
    input  sel;
    input  data_in_0;
    input  data_in_1;
    output out;

    // Local signals
    wire and0_out;
    wire and1_out;
    wire not_sel;

    //  Name  Output     Other arguments
    not not0 (not_sel, sel);
    and and0 (and0_out, data_in_0, not_sel);
    and and1 (and1_out, data_in_1, sel);
    or  or0  (out     , and0_out, and1_out);

endmodule