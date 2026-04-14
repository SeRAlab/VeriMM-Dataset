module dma_controller(
    input clk,
    input reset,
    input channel1_req,
    input channel2_req,
    output reg channel1_done,
    output reg channel2_done
);
    reg [1:0] state; // 00: idle, 01: transferring channel 1, 10: transferring channel 2

    // State encoding
    parameter IDLE = 2'b00, 
              TRANSFER1 = 2'b01, 
              TRANSFER2 = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            channel1_done <= 0;
            channel2_done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    channel1_done <= 0;
                    channel2_done <= 0;
                    if (channel1_req) begin
                        state <= TRANSFER1;
                    end else if (channel2_req) begin
                        state <= TRANSFER2;
                    end
                end
                TRANSFER1: begin
                    channel1_done <= 1; // Transfer done for channel 1
                    state <= IDLE; // Back to idle after transfer
                end
                TRANSFER2: begin
                    channel2_done <= 1; // Transfer done for channel 2
                    state <= IDLE; // Back to idle after transfer
                end
            endcase
        end
    end
endmodule