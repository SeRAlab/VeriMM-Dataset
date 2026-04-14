module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire start_tx,
    input wire data_valid,
    input wire rx_done,
    output reg tx_enable,
    output reg rx_enable,
    output reg [1:0] state
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam RECEIVE = 2'b01;
    localparam TRANSMIT = 2'b10;

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx_enable <= 0;
            rx_enable <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx_enable <= 0;
                    rx_enable <= 0;
                    if (start_tx) begin
                        state <= TRANSMIT;
                    end else if (data_valid) begin
                        state <= RECEIVE;
                    end
                end
                RECEIVE: begin
                    rx_enable <= 1;
                    if (rx_done) begin
                        state <= IDLE;
                    end
                end
                TRANSMIT: begin
                    tx_enable <= 1;
                    if (!start_tx) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule