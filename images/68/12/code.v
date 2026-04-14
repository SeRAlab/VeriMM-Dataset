module lfsr(clk, rst, q);

    input clk;
    input rst;
    output [7:0] q;
    reg [7:0] q;

    always @(posedge clk)
    begin
        if (rst)
            q <= 8'b00000001;
        else
            q <= {q[6] ^ q[5] ^ q[0], q[7:1]};
    end

endmodule