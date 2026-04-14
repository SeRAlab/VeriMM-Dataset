module sync_register(clk, reset, d, q);

    input clk;
    input reset;
    input [7:0] d;
    output [7:0] q;
    reg [7:0] q;
    initial q = 0;

    always @(posedge clk)
        if (reset)
            q <= 0;
        else
            q <= d;

endmodule