module shift_reg_16bit (
    input clk,
    input reset,
    input load,
    input [15:0] data_in,
    output reg [15:0] q
);

always @(posedge clk or posedge reset)
    if (reset)
        q <= 16'b0;
    else if (load)
        q <= data_in;
    else
        q <= {q[14:0], 1'b0};

endmodule