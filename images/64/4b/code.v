module ring_counter_5bit(
    input clk,
    input rst,
    output reg [4:0] q
);

always @(posedge clk)
    if (rst)
        q <= 5'b00001;
    else
        q <= {q[3:0], q[4]};

endmodule