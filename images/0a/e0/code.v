module stop_and_wait(
    input wire clk,
    input wire rst,
    input wire send_data,
    input wire ack_received,
    output reg data_sent,
    output reg timeout,
    output reg [3:0] state
);
    
    parameter IDLE = 4'b0000,
              SEND = 4'b0001,
              WAIT_ACK = 4'b0010,
              TIMEOUT = 4'b0011;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            data_sent <= 0;
            timeout <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (send_data) begin
                        data_sent <= 1;
                        state <= SEND;
                    end
                end
                SEND: begin
                    state <= WAIT_ACK;
                end
                WAIT_ACK: begin
                    if (ack_received) begin
                        data_sent <= 0;
                        state <= IDLE;
                    end else begin
                        timeout <= 1; // Simulate a timeout
                        state <= TIMEOUT;
                    end
                end
                TIMEOUT: begin
                    data_sent <= 1; // Retransmit data
                    state <= SEND;
                    timeout <= 0; // Reset timeout
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule