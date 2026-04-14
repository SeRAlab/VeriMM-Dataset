module top_module(q, d, clk, enable, reset);parameter
        width = 32,
        reset_value = 0;

    output reg    [(width-1):0] q;
    input  [(width-1):0] d;
    input  clk, enable, reset;

    always @(posedge clk or posedge reset)
        if (reset == 1'b1)
            q <= reset_value;
        else if (enable == 1'b1)
            q <= d;endmodule