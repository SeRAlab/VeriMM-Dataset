module nvme_controller (
    input clk,
    input reset,
    input cmd_rdy,
    input proc_done,
    output reg [1:0] state // 00: IDLE, 01: COMMAND_RECEIVED, 10: PROCESSING, 11: COMPLETED
);
    // State encoding
    parameter IDLE = 2'b00,
              COMMAND_RECEIVED = 2'b01,
              PROCESSING = 2'b10,
              COMPLETED = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (cmd_rdy) begin
                        state <= COMMAND_RECEIVED;
                    end
                end
                COMMAND_RECEIVED: begin
                    state <= PROCESSING;
                end
                PROCESSING: begin
                    if (proc_done) begin
                        state <= COMPLETED;
                    end
                end
                COMPLETED: begin
                    state <= IDLE; // Reset to IDLE after completing
                end
            endcase
        end
    end
endmodule