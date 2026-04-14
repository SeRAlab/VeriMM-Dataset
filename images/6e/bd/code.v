module sync_up_counter_20bit(
    input clk,
    input rst,
    input en,
    output reg [19:0] count
);

always @(posedge clk)
    if (rst)
        count <= 20'b00000000000000000000;
    else if (en)
        count <= count + 1;

endmodule