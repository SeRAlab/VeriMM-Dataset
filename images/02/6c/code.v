module ethernet_mac_controller (
    input clk,
    input rst,
    input rx_tx_signal, // 1 for transmit, 0 for receive
    output reg [1:0] state // 00: IDLE, 01: RECEIVE, 10: TRANSMIT
);

    parameter IDLE = 2'b00;
    parameter RECEIVE = 2'b01;
    parameter TRANSMIT = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE; // Reset to IDLE
        end else begin
            case (state)
                IDLE: begin
                    if (rx_tx_signal) // if signal indicates transmit
                        state <= TRANSMIT;
                    else
                        state <= RECEIVE; // else receive
                end
                RECEIVE: begin
                    if (rx_tx_signal)
                        state <= TRANSMIT; // switch to transmit
                    else
                        state <= RECEIVE; // remain in receive
                end
                TRANSMIT: begin
                    if (~rx_tx_signal)
                        state <= RECEIVE; // switch to receive
                    else
                        state <= TRANSMIT; // remain in transmit
                end
                default: state <= IDLE; // safe state
            endcase
        end
    end
endmodule