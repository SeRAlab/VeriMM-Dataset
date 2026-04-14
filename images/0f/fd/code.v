module sliding_window_protocol(
    input clk,
    input reset,
    input send_valid,
    input [3:0] send_data,
    input ack,
    output reg [3:0] received_data,
    output reg data_valid,
    output reg [3:0] frame_sent
);
    parameter IDLE = 2'b00, SENDING = 2'b01, WAIT_ACK = 2'b10;
    reg [1:0] state, next_state;
    reg [1:0] frame_count; // to count frames sent

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            frame_count <= 2'b00;
            frame_sent <= 4'b0000;
            data_valid <= 0;
            received_data <= 4'b0000;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (send_valid && frame_count < 2'b10) begin
                    next_state = SENDING;
                end
            end
            SENDING: begin
                frame_sent = send_data; // send data
                data_valid = 1; // indicate data sent
                next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                if (ack) begin
                    received_data = frame_sent; // receive data
                    data_valid = 0;
                    frame_count = frame_count + 1;
                    next_state = IDLE;
                end
            end
        endcase
    end
endmodule