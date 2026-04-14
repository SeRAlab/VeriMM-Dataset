module sync_johnson_counter_4bit(
    input clk,
    input rst,
    output reg [3:0] q
);

always @(posedge clk)
    if (rst)
        q <= 4'b0000;
    else
        q <= {q[2:0], ~q[3]};

endmodule