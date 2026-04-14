module shift_register_4bit (
    input clk,
    input rst,
    input load,
    input [3:0] data_in,
    output reg [3:0] q
);

always @(posedge clk or posedge rst)
    if (rst)
        q <= 4'b0;
    else if (load)
        q <= data_in;
    else
        q <= {q[2:0], 1'b0};

endmodule