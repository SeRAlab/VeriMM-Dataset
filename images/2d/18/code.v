module up_down_counter (
    input clk,
    input reset,
    input enable,
    input up,
    input down,
    output reg [3:0] count
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000; // Reset counter to 0
        end else if (enable) begin
            if (up) begin
                count <= count + 1; // Count up
            end else if (down) begin
                count <= count - 1; // Count down
            end
        end
    end
endmodule