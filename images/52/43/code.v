module abs_value (
        input signed [3:0] a,
        output [3:0] abs);

    assign abs = (a < 0) ? -a : a;

endmodule