module top_module(f, a, b, select);input a, b, select;
    output f;
    assign f = (select & a) | ((~select) & b);endmodule