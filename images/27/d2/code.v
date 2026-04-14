module SLAM(
    input wire clk,
    input wire reset,
    input wire [1:0] direction, // 00: up, 01: down, 10: left, 11: right
    output reg [7:0] x,
    output reg [7:0] y
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x <= 8'd0;
            y <= 8'd0;
        end else begin
            case (direction)
                2'b00: y <= y + 1; // move up
                2'b01: y <= y - 1; // move down
                2'b10: x <= x - 1; // move left
                2'b11: x <= x + 1; // move right
            endcase
        end
    end
endmodule