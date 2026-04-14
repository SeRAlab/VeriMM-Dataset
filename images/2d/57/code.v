module ethernet_mac_controller (
    input clk,
    input reset,
    input start_tx,
    input start_rx,
    output reg [1:0] state // 00: IDLE, 01: TRANSMIT, 10: RECEIVE
);

    // State encoding
    localparam IDLE     = 2'b00;
    localparam TRANSMIT = 2'b01;
    localparam RECEIVE  = 2'b10;

    // Sequential logic for state machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; // Reset to IDLE state
        end else begin
            case (state)
                IDLE: begin
                    if (start_tx) begin
                        state <= TRANSMIT; // Start transmitting
                    end else if (start_rx) begin
                        state <= RECEIVE; // Start receiving
                    end
                end
                TRANSMIT: begin
                    if (!start_tx) begin
                        state <= IDLE; // Go back to IDLE if transmission is done
                    end
                end
                RECEIVE: begin
                    if (!start_rx) begin
                        state <= IDLE; // Go back to IDLE if reception is done
                    end
                end
            endcase
        end
    end
endmodule