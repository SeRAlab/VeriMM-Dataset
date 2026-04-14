module up_down_counter_8bit (
    input clk,
    input reset,
    input up_down, // 1 for up, 0 for down
    output reg [7:0] count);

always @(posedge clk) begin
    if (reset)
        count <= 8'b0;
    else if (up_down)
        count <= count + 1;
    else
        count <= count - 1;
    end
    
endmodule