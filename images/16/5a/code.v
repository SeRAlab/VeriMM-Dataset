module SLAM (
    input clk,
    input rst,
    input [1:0] command, // 00: up, 01: down, 10: left, 11: right
    output reg [7:0] x,
    output reg [7:0] y
);
    initial begin
        x = 8'b0;
        y = 8'b0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x <= 8'b0;
            y <= 8'b0;
        end else begin
            case (command)
                2'b00: y <= y + 1; // move up
                2'b01: y <= y - 1; // move down
                2'b10: x <= x - 1; // move left
                2'b11: x <= x + 1; // move right
            endcase
        end
    end
endmodule