module up_down_counter (
    input clk,
    input reset,
    input control, // 1 for up, 0 for down
    output reg [2:0] count // 3-bit count output
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b000; // Reset to 0
        end else begin
            if (control) begin
                count <= count + 1; // Count up
            end else begin
                count <= count - 1; // Count down
            end
        end
    end
endmodule