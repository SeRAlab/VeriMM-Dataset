module sliding_window_protocol (
    input clk,
    input reset,
    input send_packet,
    input ack_received,
    output reg [3:0] window_start,
    output reg [3:0] window_end,
    output reg [3:0] packets_in_flight
);

    parameter WINDOW_SIZE = 4;
    parameter IDLE = 2'b00, SENDING = 2'b01, WAITING_ACK = 2'b10;
    reg [1:0] state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            window_start <= 0;
            window_end <= 0;
            packets_in_flight <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (send_packet && packets_in_flight < WINDOW_SIZE) begin
                    next_state = SENDING;
                end
            end
            SENDING: begin
                if (packets_in_flight < WINDOW_SIZE) begin
                    window_end <= window_end + 1;
                    packets_in_flight <= packets_in_flight + 1;
                    next_state = WAITING_ACK;
                end
            end
            WAITING_ACK: begin
                if (ack_received) begin
                    window_start <= window_start + 1;
                    packets_in_flight <= packets_in_flight - 1;
                    next_state = IDLE;
                end
            end
        endcase
    end
endmodule