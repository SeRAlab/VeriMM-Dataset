module sync_counter_8bit (
    input clk,
    input rst,
    input en,
    output reg [7:0] count
);

always @(posedge clk or posedge rst)
    if (rst) 
        count <= 8'b0;
    else if (en) 
        count <= count + 1'b1;

endmodule