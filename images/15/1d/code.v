module bluetooth_fsm (
    input wire clk,
    input wire reset,
    input wire connect_signal,
    input wire transfer_signal,
    output reg [1:0] state // 00: IDLE, 01: CONNECTED, 10: DATA_TRANSFER
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter CONNECTED = 2'b01;
    parameter DATA_TRANSFER = 2'b10;

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; // Reset state to IDLE
        end else begin
            case (state)
                IDLE: begin
                    if (connect_signal)
                        state <= CONNECTED; // Transition to CONNECTED state
                end
                CONNECTED: begin
                    if (transfer_signal)
                        state <= DATA_TRANSFER; // Transition to DATA_TRANSFER
                end
                DATA_TRANSFER: begin
                    if (!transfer_signal)
                        state <= CONNECTED; // Go back to CONNECTED state
                    else if (!connect_signal)
                        state <= IDLE; // Go back to IDLE if no connect signal
                end
                default: state <= IDLE; // Default case
            endcase
        end
    end
endmodule