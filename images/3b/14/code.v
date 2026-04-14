module dma_controller (
    input wire clk,
    input wire request1,
    input wire request2,
    input wire acknowledge1,
    input wire acknowledge2,
    output reg active_channel,
    output reg transfer_complete
);

    reg state; // 0 for channel 1, 1 for channel 2

    always @(posedge clk) begin
        if (request1 && !acknowledge1 && !state) begin
            active_channel <= 1'b0; // Channel 1 is active
            transfer_complete <= 1'b0; // Transfer not complete
            state <= 1'b0;
        end else if (request2 && !acknowledge2 && state) begin
            active_channel <= 1'b1; // Channel 2 is active
            transfer_complete <= 1'b0; // Transfer not complete
            state <= 1'b1;
        end else if (acknowledge1 && !state) begin
            transfer_complete <= 1'b1; // Transfer complete for channel 1
        end else if (acknowledge2 && state) begin
            transfer_complete <= 1'b1; // Transfer complete for channel 2
        end
    end
endmodule