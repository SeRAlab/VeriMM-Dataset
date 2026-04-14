module shift_register
    (
        input clk,
        input rst,
        input serial_in,
        output reg [3:0] q
    );

always @(posedge clk or posedge rst)
    if (rst)
        q <= 4'd0;
    else
        q <= {serial_in, q[3:1]};

endmodule