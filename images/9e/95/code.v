module top_module(
    input a, b, c,
    input select,
    output w, x, y, z
);assign w = a;
    assign z = c;

    // 2:1 MUX to select between b and c
    assign x = (select == 1'b0) ? b : c;
    assign y = (select == 1'b1) ? b : c;

endmodule