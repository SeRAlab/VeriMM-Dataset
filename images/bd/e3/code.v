module top_module(
    input[3:0] fact_f,
    input[3:0] fact_l,
    input[3:0] set_f,
    input[3:0] set_l,
    output stop
    );assign stop = !((fact_f^set_f) || (fact_l^set_l));
endmodule