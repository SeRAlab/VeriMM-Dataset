module lfsr(clk, rst, q);

    input  clk;
    input  rst;
    output reg [4:0] q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 5'b11111;
        else
            q <= {q[3:0], q[4] ^ q[2]};
    end
    
endmodule