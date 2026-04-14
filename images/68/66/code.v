module nor_logic_alternate (
    input x,
    input y,
    output z);assign z = ~(x | y);

endmodule