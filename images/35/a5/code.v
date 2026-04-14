module dma_controller (
    input clk,
    input rst,
    input channel_1_start,
    input channel_2_start,
    input [7:0] source_address_1,
    input [7:0] destination_address_1,
    input [7:0] source_address_2,
    input [7:0] destination_address_2,
    input [7:0] data,
    output reg channel_1_done,
    output reg channel_2_done
);

    reg [2:0] state; // 0: idle, 1: transfer_channel_1, 2: transfer_channel_2, 3: done_channel_1, 4: done_channel_2
    reg [3:0] transfer_count; // Counts the number of cycles of transfer

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            channel_1_done <= 0;
            channel_2_done <= 0;
            transfer_count <= 0;
        end else begin
            case (state)
                0: begin // idle state
                    if (channel_1_start) begin
                        state <= 1; // start channel 1 transfer
                        transfer_count <= 0;
                    end else if (channel_2_start) begin
                        state <= 2; // start channel 2 transfer
                        transfer_count <= 0;
                    end
                end
                1: begin // transferring channel 1
                    // Transfer data logic for channel 1 here (skipped for simplicity)
                    transfer_count <= transfer_count + 1;
                    if (transfer_count == 4) begin
                        state <= 3; // done with channel 1
                    end
                end
                2: begin // transferring channel 2
                    // Transfer data logic for channel 2 here (skipped for simplicity)
                    transfer_count <= transfer_count + 1;
                    if (transfer_count == 4) begin
                        state <= 4; // done with channel 2
                    end
                end
                3: begin // done channel 1
                    channel_1_done <= 1;
                    state <= 0; // go back to idle
                end
                4: begin // done channel 2
                    channel_2_done <= 1;
                    state <= 0; // go back to idle
                end
            endcase
        end
    end
endmodule