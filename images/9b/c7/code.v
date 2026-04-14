module binary_counter_with_load(
    input clk,
    input reset,
    input load,
    input [2:0] data,
    output reg [2:0] count);always @(posedge clk)
    if (reset)
        count <= 0;
    else if (load)
        count <= data;
    else
        count <= count + 1;
        
endmodule