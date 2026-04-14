module sliding_window_protocol (
    input wire clk,
    input wire rst,
    input wire send,
    input wire ack,
    output reg [1:0] frame_sent,
    output reg [1:0] window_position
);
    reg [1:0] state;
    parameter IDLE = 2'd0, SENDING = 2'd1, WAITING_ACK = 2'd2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            frame_sent <= 2'd0;
            window_position <= 2'd0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (send && (window_position < 2'd4)) begin
                        frame_sent <= window_position;
                        state <= SENDING;
                    end
                end
                SENDING: begin
                    state <= WAITING_ACK;
                end
                WAITING_ACK: begin
                    if (ack) begin
                        window_position <= window_position + 1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule