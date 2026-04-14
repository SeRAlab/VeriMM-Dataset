module up_down_counter (
    input clk,
    input reset,
    input enable,
    input up, // 1 for up counting, 0 for down counting
    output reg [15:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 16'b0;
        end else if (enable) begin
            if (up) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
    end
endmodule