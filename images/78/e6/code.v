module top_module(
    input pullup0,
    input pulldown0,
    output HI,
    output LO
);assign HI = pullup0 & ~pulldown0;
    assign LO = ~pullup0 & pulldown0;

endmodule