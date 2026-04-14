module ethernet_mac_controller (
    input clk,
    input reset,
    input start_transmit,
    input ack_received,
    output reg frame_sent,
    output reg [1:0] state // 0: IDLE, 1: TRANSMIT, 2: WAIT_FOR_ACK
);

    // State definitions
    parameter IDLE = 2'b00;
    parameter TRANSMIT = 2'b01;
    parameter WAIT_FOR_ACK = 2'b10;

    // State register
    reg [1:0] current_state, next_state;

    // Sequential logic for state transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state
    always @(*) begin
        case (current_state)
            IDLE: begin
                frame_sent = 0;
                if (start_transmit) begin
                    next_state = TRANSMIT;
                end else begin
                    next_state = IDLE;
                end
            end
            TRANSMIT: begin
                frame_sent = 1;
                next_state = WAIT_FOR_ACK;
            end
            WAIT_FOR_ACK: begin
                frame_sent = 0;
                if (ack_received) begin
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_FOR_ACK;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule