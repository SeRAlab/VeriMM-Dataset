module stop_and_wait (
    input clk,
    input reset,
    input [7:0] data_in,
    input ack,
    output reg [7:0] data_out,
    output reg send,
    output reg timeout
);
    reg [2:0] state;
    reg [2:0] next_state;
    reg [3:0] timer;

    parameter IDLE = 3'b000, SEND = 3'b001, WAIT_ACK = 3'b010, TIMEOUT = 3'b011, RESEND = 3'b100;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            timer <= 0;
            send <= 0;
            timeout <= 0;
        end else begin
            state <= next_state;
            if (next_state == WAIT_ACK) begin
                if (timer < 4'd10) begin
                    timer <= timer + 1;
                end
            end else begin
                timer <= 0;
            end
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                send = 0;
                timeout = 0;
                next_state = SEND;
            end
            SEND: begin
                data_out = data_in;
                send = 1;
                next_state = WAIT_ACK;
            end
            WAIT_ACK: begin
                send = 0;
                if (ack) begin
                    next_state = IDLE;
                end else if (timer >= 4'd10) begin
                    timeout = 1;
                    next_state = RESEND;
                end else begin
                    next_state = WAIT_ACK;
                end
            end
            RESEND: begin
                send = 1;
                next_state = WAIT_ACK;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule