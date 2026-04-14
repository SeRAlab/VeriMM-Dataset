module top_module(
    go,
    control_key
);input control_key;
    output go;
    assign go = control_key;endmodule