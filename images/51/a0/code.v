module up_down_counter (
    input clk,
    input reset,
    input up_down, // 1 for up, 0 for down
    output reg [5:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 6'b000000;
        end else if (up_down) begin
            count <= count + 6'b000001;
        end else begin
            count <= count - 6'b000001;
        end
    end
endmodule