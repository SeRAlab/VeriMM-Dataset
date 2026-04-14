module sync_counter_8bit_clr(
    input clk,
    input clr_n,
    input en,
    output reg [7:0] count
);

always @(posedge clk or negedge clr_n)
    if (!clr_n)
        count <= 8'b00000000;
    else if (en)
        count <= count + 1;

endmodule