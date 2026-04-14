module gpio_controller (
    input wire clk,
    input wire rst,
    input wire [4:0] set,
    input wire [4:0] clear,
    output reg [4:0] state
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 5'b00000;
        end else begin
            state <= (state | set) & ~clear;
        end
    end
endmodule