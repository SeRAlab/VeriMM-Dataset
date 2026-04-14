module binary_counter_3bit (
    input clk,
    input reset,
    input enable,
    output reg [2:0] count);

always @(posedge clk) begin
    if (reset)
        count <= 3'b000;
    else if (enable)
        count <= count + 1;
    end
    
endmodule