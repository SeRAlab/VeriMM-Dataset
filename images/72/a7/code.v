module truth_table_circuit (
        input p,
        input q,
        input r,
        output s);

assign s = (~p & ~q & ~r) |
           (~p & q & ~r) |
           (p & q & r);

endmodule