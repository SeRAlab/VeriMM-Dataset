module sync_counter_12bit_load(
    input clk,
    input rst,
    input en,
    input load,
    input [11:0] load_value,
    output reg [11:0] count
);

always @(posedge clk)
    if (rst)
        count <= 12'b000000000000;
    else if (load)
        count <= load_value;
    else if (en)
        count <= count + 1;

endmodule