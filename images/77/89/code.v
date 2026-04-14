module binary_counter(clk, reset, q);

    input clk;
    input reset;
    output [3:0] q;
    reg [3:0] q;
    initial q = 0;

    always @(posedge clk)
        begin
            if (reset)
                q <= 0;
            else
                q <= q + 1;
        end

endmodule