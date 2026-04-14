module dma_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg [1:0] current_channel
);

reg [1:0] next_channel;
reg [1:0] state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 0;
        current_channel <= 0;
    end else if (start) begin
        if (req0 && state == 0) begin
            current_channel <= 2'b00; // Channel 0
            state <= 1;
        end else if (req1 && state == 1) begin
            current_channel <= 2'b01; // Channel 1
            state <= 2;
        end else if (req2 && state == 2) begin
            current_channel <= 2'b10; // Channel 2
            state <= 3;
        end else if (req3 && state == 3) begin
            current_channel <= 2'b11; // Channel 3
            state <= 0;
        end
    end
end

endmodule