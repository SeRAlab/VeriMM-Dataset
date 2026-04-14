module ring_counter(clk, rst, q);

    input clk;
    input rst;
    output [3:0] q;
    reg [3:0] q;

    always @(posedge clk)
    begin
        if (rst)
            q <= 4'b0001;
        else
            q <= {q[0], q[3:1]};
    end

endmodule