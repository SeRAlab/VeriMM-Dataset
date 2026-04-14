module dma_controller (
    input clk,
    input reset,
    input request1,
    input request2,
    output reg active_channel,
    output reg transfer_complete
);
    reg state; // 0 for Channel 1, 1 for Channel 2

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            active_channel <= 0;
            transfer_complete <= 0;
        end else begin
            if (request1 && !request2) begin
                state <= 0; // Channel 1 requested
            end else if (request2 && !request1) begin
                state <= 1; // Channel 2 requested
            end
            
            if (state == 0 && request1) begin
                active_channel <= 0;
                transfer_complete <= 1; // transfer complete for Channel 1
            end else if (state == 1 && request2) begin
                active_channel <= 1;
                transfer_complete <= 1; // transfer complete for Channel 2
            end else begin
                transfer_complete <= 0; // no active transfer
            end
        end
    end
endmodule