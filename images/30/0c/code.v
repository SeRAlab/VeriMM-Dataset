module bluetooth_controller (
    input wire clk,
    input wire reset,
    input wire start_connection,
    input wire confirm_connection,
    input wire disconnect,
    output reg [1:0] state
);

    // State encoding
    parameter IDLE = 2'b00, CONNECTING = 2'b01, CONNECTED = 2'b10, DISCONNECTED = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_connection) state <= CONNECTING;
                end
                CONNECTING: begin
                    if (confirm_connection) state <= CONNECTED;
                    else if (disconnect) state <= DISCONNECTED;
                end
                CONNECTED: begin
                    if (disconnect) state <= DISCONNECTED;
                end
                DISCONNECTED: begin
                    if (start_connection) state <= CONNECTING; // Can start connection from DISCONNECTED
                end
            endcase
        end
    end
endmodule