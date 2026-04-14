module sync_down_counter_12bit(
    input clk,
    input rst,
    input en,
    output reg [11:0] count
);

always @(posedge clk)
    if (rst)
        count <= 12'b111111111111;
    else if (en)
        count <= count - 1;

endmodule