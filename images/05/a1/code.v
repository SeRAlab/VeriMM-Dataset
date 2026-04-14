module ethernet_mac_controller (
    input clk,
    input reset,
    input start_tx,
    input start_rx,
    output reg [1:0] state // 00 = IDLE, 01 = TRANSMIT, 10 = RECEIVE
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam TRANSMIT = 2'b01;
    localparam RECEIVE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_tx) begin
                        state <= TRANSMIT;
                    end else if (start_rx) begin
                        state <= RECEIVE;
                    end
                end
                TRANSMIT: begin
                    // After transmission, return to IDLE
                    state <= IDLE;
                end
                RECEIVE: begin
                    // After reception, return to IDLE
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule