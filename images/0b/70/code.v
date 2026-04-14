module up_down_counter (
    input clk,
    input reset,
    input enable,
    input up_down, // 1 for up, 0 for down
    output reg [3:0] count,
    output reg max_reached,
    output reg min_reached
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000;
            max_reached <= 0;
            min_reached <= 1;
        end else if (enable) begin
            if (up_down) begin
                if (count < 4'b1111) begin
                    count <= count + 1;
                    max_reached <= (count == 4'b1110); // max reached when count was 14
                    min_reached <= 0;
                end else begin
                    max_reached <= 1;
                end
            end else begin
                if (count > 4'b0000) begin
                    count <= count - 1;
                    min_reached <= (count == 4'b0001); // min reached when count was 1
                    max_reached <= 0;
                end else begin
                    min_reached <= 1;
                end
            end
        end
    end
endmodule