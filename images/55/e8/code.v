module register_16bit(
    input clk,
    input rst,
    input load,
    input [15:0] data_in,
    output reg [15:0] data_out
);

always @(posedge clk or posedge rst)
    if (rst)
        data_out <= 16'b0;
    else if (load)
        data_out <= data_in;

endmodule