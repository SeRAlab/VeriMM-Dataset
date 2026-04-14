module ring_counter(clk, reset, q);

    input clk;
    input reset;
    output [3:0] q;
    reg [3:0] q;
    initial q = 4'b0001;

    always @(posedge clk)
        begin
            if (reset)
                q <= 4'b0001;
            else
                q <= {q[2:0], q[3]};
        end

endmodule