module sync_down_counter_8bit(
    input clk,
    input rst,
    input en,
    output reg [7:0] count
);

always @(posedge clk)
    if (rst)
        count <= 8'b00000000;
    else if (en)
        count <= count - 1;

endmodule