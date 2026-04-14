module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire trigger,
    output reg [1:0] state,  // 00: IDLE, 01: RECEIVE, 10: TRANSMIT
    output reg ack
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter RECEIVE = 2'b01;
    parameter TRANSMIT = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            ack <= 0;
        end else begin
            case (state)
                IDLE: begin
                    ack <= 0;
                    if (trigger) begin
                        state <= RECEIVE;
                    end
                end
                RECEIVE: begin
                    ack <= 1;
                    if (trigger) begin
                        state <= TRANSMIT;
                    end
                end
                TRANSMIT: begin
                    ack <= 1;
                    if (trigger) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule