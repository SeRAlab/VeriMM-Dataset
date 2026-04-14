module timer(
    input clk,
    input reset,
    input enable,
    output reg [15:0] count,
    output reg max_flag
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 16'b0;
            max_flag <= 1'b0;
        end else if (enable) begin
            if (count == 16'hFFFF) begin
                count <= 16'b0;
                max_flag <= 1'b1; // Set flag when wrapping around
            end else begin
                count <= count + 1;
                max_flag <= 1'b0;
            end
        end
    end
endmodule