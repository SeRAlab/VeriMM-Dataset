module top_module(output reg o, input i0, i1);always @ (i0 or i1)
        o = ~(i0 | i1);
endmodule