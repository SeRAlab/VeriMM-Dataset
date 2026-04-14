module top_module(
    input reset,
    output reg clock
);always @(posedge reset or negedge clock)
    if (reset)
        clock <= 0;
    else
        #5 clock <= ~clock;

endmodule