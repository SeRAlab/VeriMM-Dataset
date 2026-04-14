module up_down_counter (
    input clk,
    input rst,
    input up_down,  // 1 for up, 0 for down
    output reg [3:0] count
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0000;
        end else begin
            if (up_down) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
    end
endmodule