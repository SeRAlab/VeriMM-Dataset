module gpio_controller (
    input wire i0,
    input wire i1,
    input wire i2,
    input wire i3,
    input wire i4,
    output wire o
);
    assign o = i0 | i1 | i2 | i3 | i4;
endmodule