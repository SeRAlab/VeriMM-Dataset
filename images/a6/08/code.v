module johnson_counter(clk, reset, q);

    input clk;
    input reset;
    output [2:0] q;
    reg [2:0] q;
    initial q = 3'b000;

    always @(posedge clk)
        begin
            if (reset)
                q <= 3'b000;
            else
                q <= {q[1:0], ~q[2]};
        end

endmodule