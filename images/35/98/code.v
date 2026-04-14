module dma_controller(
    input wire clk,
    input wire reset,
    input wire start_ch1,
    input wire start_ch2,
    output reg busy_ch1,
    output reg busy_ch2,
    output reg done_ch1,
    output reg done_ch2
);
    
    reg [1:0] state_ch1;
    reg [1:0] state_ch2;

    parameter IDLE = 2'b00, ACTIVE = 2'b01, DONE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_ch1 <= IDLE;
            state_ch2 <= IDLE;
            busy_ch1 <= 0;
            busy_ch2 <= 0;
            done_ch1 <= 0;
            done_ch2 <= 0;
        end else begin
            // Channel 1 State Machine
            case (state_ch1)
                IDLE: begin
                    if (start_ch1) begin
                        busy_ch1 <= 1;
                        state_ch1 <= ACTIVE;
                        done_ch1 <= 0;
                    end
                end
                ACTIVE: begin
                    // Simulate data transfer
                    busy_ch1 <= 1;
                    state_ch1 <= DONE;
                end
                DONE: begin
                    busy_ch1 <= 0;
                    done_ch1 <= 1;
                    state_ch1 <= IDLE;
                end
            endcase

            // Channel 2 State Machine
            case (state_ch2)
                IDLE: begin
                    if (start_ch2) begin
                        busy_ch2 <= 1;
                        state_ch2 <= ACTIVE;
                        done_ch2 <= 0;
                    end
                end
                ACTIVE: begin
                    // Simulate data transfer
                    busy_ch2 <= 1;
                    state_ch2 <= DONE;
                end
                DONE: begin
                    busy_ch2 <= 0;
                    done_ch2 <= 1;
                    state_ch2 <= IDLE;
                end
            endcase
        end
    end
endmodule