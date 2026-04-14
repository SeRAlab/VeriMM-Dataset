module sliding_window_protocol (
    input wire clk,
    input wire rst,
    input wire data_ready,
    input wire ack,
    output reg [1:0] state // 00: IDLE, 01: SEND, 10: WAIT
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter SEND = 2'b01;
    parameter WAIT = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (data_ready) begin
                        state <= SEND;
                    end
                end
                SEND: begin
                    state <= WAIT;
                end
                WAIT: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule