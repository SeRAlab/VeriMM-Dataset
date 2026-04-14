module top_module(
    input  USER_SIGNAL_TO_GLOBAL_BUFFER,
    output GLOBAL_BUFFER_OUTPUT
);assign GLOBAL_BUFFER_OUTPUT = USER_SIGNAL_TO_GLOBAL_BUFFER;

`ifdef TIMING
    specify
        (USER_SIGNAL_TO_GLOBAL_BUFFER => GLOBAL_BUFFER_OUTPUT) = (0:0:0, 0:0:0);
    endspecify
`endif

endmodule