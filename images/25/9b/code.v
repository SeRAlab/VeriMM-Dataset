module timer_32bit (
    input clk,
    input reset,
    input enable,
    output reg [31:0] count,
    output reg max_reached
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 32'b0;
            max_reached <= 1'b0;
        end else if (enable) begin
            if (count == 32'hFFFFFFFF) begin
                count <= 32'b0;
                max_reached <= 1'b1;
            end else begin
                count <= count + 1;
                max_reached <= 1'b0;
            end
        end
    end
endmodule