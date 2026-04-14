module timer_16bit (
    input clk,
    input reset,
    input enable,
    output reg [15:0] count
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 16'b0;
        end else if (enable) begin
            if (count == 16'b1111111111111111) begin
                count <= 16'b0; // reset to zero when reaching the max value
            end else begin
                count <= count + 1;
            end
        end
    end
endmodule