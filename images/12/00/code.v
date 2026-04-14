module sliding_window_controller (
    input wire clk,
    input wire reset,
    input wire send,
    input wire ack,
    output reg [3:0] window_status,
    output reg [1:0] state
);
    parameter IDLE = 2'b00, SENDING = 2'b01, WAITING_ACK = 2'b10;
    parameter WINDOW_SIZE = 4;

    reg [3:0] packets_sent;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            window_status <= 0;
            packets_sent <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (send && packets_sent < WINDOW_SIZE) begin
                        packets_sent <= packets_sent + 1;
                        window_status <= packets_sent + 1;
                        state <= SENDING;
                    end
                end
                SENDING: begin
                    if (ack) begin
                        packets_sent <= packets_sent - 1;
                        state <= WAITING_ACK;
                    end
                end
                WAITING_ACK: begin
                    if (send && packets_sent < WINDOW_SIZE) begin
                        packets_sent <= packets_sent + 1;
                        window_status <= packets_sent + 1;
                        state <= SENDING;
                    end else if (!send) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule