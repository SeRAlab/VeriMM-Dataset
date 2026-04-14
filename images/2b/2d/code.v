module dma_controller(
    input clk,
    input rst,
    input channel0_req,
    input channel0_valid,
    input channel1_req,
    input channel1_valid,
    output reg channel0_grant,
    output reg channel1_grant,
    output reg transfer_complete
);
    reg [1:0] state; // 00: Idle, 01: Channel 0 Transfer, 10: Channel 1 Transfer

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00;
            channel0_grant <= 0;
            channel1_grant <= 0;
            transfer_complete <= 0;
        end else begin
            transfer_complete <= 0; // Reset transfer_complete at each clock cycle
            case (state)
                2'b00: begin // Idle state
                    if (channel0_req && channel0_valid) begin
                        state <= 2'b01; // Move to Channel 0 Transfer
                        channel0_grant <= 1;
                        channel1_grant <= 0;
                    end else if (channel1_req && channel1_valid) begin
                        state <= 2'b10; // Move to Channel 1 Transfer
                        channel0_grant <= 0;
                        channel1_grant <= 1;
                    end
                end
                2'b01: begin // Channel 0 Transfer
                    if (channel0_valid) begin
                        state <= 2'b00; // Back to Idle
                        transfer_complete <= 1;
                    end
                end
                2'b10: begin // Channel 1 Transfer
                    if (channel1_valid) begin
                        state <= 2'b00; // Back to Idle
                        transfer_complete <= 1;
                    end
                end
            endcase
        end
    end
endmodule