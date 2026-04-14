module up_down_counter (
    input clk,
    input reset,
    input enable,
    input direction, // 1 for up, 0 for down
    output reg [3:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 4'b0000;
    end else if (enable) begin
        if (direction) begin
            if (count < 4'b1111) begin
                count <= count + 1;
            end
        end else begin
            if (count > 4'b0000) begin
                count <= count - 1;
            end
        end
    end
end

endmodule