module ethernet_mac_controller (
    input clk,
    input rst,
    input start_tx,
    input start_rx,
    output reg [1:0] state, // IDLE=0, TRANSMIT=1, RECEIVE=2
    output reg tx_active,
    output reg rx_active
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter TRANSMIT = 2'b01;
    parameter RECEIVE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tx_active <= 1'b0;
            rx_active <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start_tx) begin
                        state <= TRANSMIT;
                        tx_active <= 1'b1;
                    end else if (start_rx) begin
                        state <= RECEIVE;
                        rx_active <= 1'b1;
                    end
                end
                TRANSMIT: begin
                    // Transmission logic here
                    // For simplicity, just go back to IDLE after transmit
                    state <= IDLE;
                    tx_active <= 1'b0;
                end
                RECEIVE: begin
                    // Reception logic here
                    // For simplicity, just go back to IDLE after receive
                    state <= IDLE;
                    rx_active <= 1'b0;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule