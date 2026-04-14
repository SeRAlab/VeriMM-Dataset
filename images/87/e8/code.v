module binary_counter_3bit(
    input clk,
    input rst,
    output reg [2:0] count);
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 3'b000; // Synchronous reset
        else
            count <= count + 1; // Increment counter on each clock pulse
    end
endmodule