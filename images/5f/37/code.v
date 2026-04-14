module johnson_counter(clk, rst, q);

    input clk;
    input rst;
    output [2:0] q;
    reg [2:0] q;

    always @(posedge clk)
    begin
        if (rst)
            q <= 3'b000;
        else
            q <= {q[1:0], ~q[2]};
    end

endmodule