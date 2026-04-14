module position_encoder (
    input clk,
    input reset,
    input direction, // 1 for forward, 0 for backward
    output reg [3:0] position
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            position <= 4'b0000; // reset position to 0
        else begin
            if (direction) begin
                position <= (position == 4'b1111) ? 4'b0000 : position + 1'b1; // wrap around
            end else begin
                position <= (position == 4'b0000) ? 4'b1111 : position - 1'b1; // wrap around
            end
        end
    end
endmodule