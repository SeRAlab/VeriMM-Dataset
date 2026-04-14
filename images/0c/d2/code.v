module sata_controller (
    input wire clk,
    input wire reset,
    input wire start_transmit,
    input wire start_receive,
    output reg [1:0] state, // 00: IDLE, 01: TRANSMIT, 10: RECEIVE
    output reg status // 0: idle, 1: transmitting, 2: receiving
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter TRANSMIT = 2'b01;
    parameter RECEIVE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            status <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start_transmit) begin
                        state <= TRANSMIT;
                        status <= 1;
                    end else if (start_receive) begin
                        state <= RECEIVE;
                        status <= 2;
                    end
                end
                TRANSMIT: begin
                    if (!start_transmit) begin
                        state <= IDLE;
                        status <= 0;
                    end
                end
                RECEIVE: begin
                    if (!start_receive) begin
                        state <= IDLE;
                        status <= 0;
                    end
                end
            endcase
        end
    end
endmodule