module shift_register_8bit(
    input clk,
    input rst_n,
    input load,
    input shift_left,
    input shift_right,
    input [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk or negedge rst_n)
    if (!rst_n)
        data_out <= 8'b00000000;
    else if (load)
        data_out <= data_in;
    else if (shift_left)
        data_out <= {data_out[6:0], 1'b0};
    else if (shift_right)
        data_out <= {1'b0, data_out[7:1]};

endmodule