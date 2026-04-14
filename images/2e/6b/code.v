module ethernet_mac_controller(
    input clk,
    input reset,
    input start,
    input ack,
    output reg [1:0] state // 00: IDLE, 01: TRANSMITTING, 10: WAITING_FOR_ACK
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter TRANSMITTING = 2'b01;
    parameter WAITING_FOR_ACK = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= TRANSMITTING;
                    end
                end
                TRANSMITTING: begin
                    state <= WAITING_FOR_ACK;
                end
                WAITING_FOR_ACK: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule