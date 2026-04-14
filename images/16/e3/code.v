module sliding_window_controller (
    input clk,
    input reset,
    input send_frame,
    input receive_frame,
    input ack,
    output reg [1:0] sender_state,
    output reg [1:0] receiver_state
);

    parameter IDLE = 2'b00;
    parameter SENDING = 2'b01;
    parameter WAITING_ACK = 2'b10;
    parameter RECEIVING = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sender_state <= IDLE;
            receiver_state <= IDLE;
        end else begin
            case (sender_state)
                IDLE: begin
                    if (send_frame) begin
                        sender_state <= SENDING;
                    end
                end
                SENDING: begin
                    if (ack) begin
                        sender_state <= IDLE; // Frame sent and acknowledged
                    end else begin
                        sender_state <= WAITING_ACK; // Wait for acknowledgment
                    end
                end
                WAITING_ACK: begin
                    if (ack) begin
                        sender_state <= IDLE;
                    end
                end
            endcase
            
            case (receiver_state)
                IDLE: begin
                    if (receive_frame) begin
                        receiver_state <= RECEIVING;
                    end
                end
                RECEIVING: begin
                    receiver_state <= IDLE; // Frame received
                end
            endcase
        end
    end
endmodule