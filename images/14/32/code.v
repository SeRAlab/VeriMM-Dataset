module dma_controller (
    input clk,
    input reset,
    input start_channel1,
    input start_channel2,
    output reg transfer_complete_channel1,
    output reg transfer_complete_channel2
);
    reg [1:0] state; // 0: idle, 1: transferring channel 1, 2: transferring channel 2
    parameter IDLE = 2'b00, CHANNEL1 = 2'b01, CHANNEL2 = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            transfer_complete_channel1 <= 0;
            transfer_complete_channel2 <= 0;
        end else begin
            case (state)
                IDLE: begin
                    transfer_complete_channel1 <= 0;
                    transfer_complete_channel2 <= 0;
                    if (start_channel1) begin
                        state <= CHANNEL1;
                    end else if (start_channel2) begin
                        state <= CHANNEL2;
                    end
                end
                CHANNEL1: begin
                    // Simulate data transfer
                    // Assuming transfer takes 1 clock cycle for simplicity
                    transfer_complete_channel1 <= 1;
                    state <= IDLE;
                end
                CHANNEL2: begin
                    // Simulate data transfer
                    // Assuming transfer takes 1 clock cycle for simplicity
                    transfer_complete_channel2 <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule