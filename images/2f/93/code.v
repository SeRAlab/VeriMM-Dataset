module up_down_counter (
    input clk,
    input rst_n,
    input enable,
    input mode, // 0 for up, 1 for down
    output reg [3:0] count
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0000;
        end else if (enable) begin
            if (mode == 0) begin
                count <= (count == 4'b1111) ? 4'b0000 : count + 1;
            end else begin
                count <= (count == 4'b0000) ? 4'b1111 : count - 1;
            end
        end
    end
endmodule