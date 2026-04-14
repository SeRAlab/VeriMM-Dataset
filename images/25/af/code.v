module bluetooth_fsm(
    input wire clk,
    input wire reset,
    input wire start,
    input wire connect_done,
    output reg [1:0] state
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; // Reset to IDLE state
        end else begin
            case (state)
                IDLE: begin
                    if (start)
                        state <= CONNECTING;
                end
                CONNECTING: begin
                    if (connect_done)
                        state <= CONNECTED;
                end
                CONNECTED: begin
                    if (reset)
                        state <= IDLE; // Go back to IDLE if reset
                end
            endcase
        end
    end
endmodule