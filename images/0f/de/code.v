module BluetoothController (
    input wire clk,
    input wire reset,
    input wire connect,
    input wire disconnect,
    output reg [1:0] state
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter CONNECTED = 2'b01;
    parameter DISCONNECTED = 2'b10;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; // Go to IDLE on reset
        end else begin
            case (state)
                IDLE: begin
                    if (connect) begin
                        state <= CONNECTED; // Connect signal received
                    end
                end
                
                CONNECTED: begin
                    if (disconnect) begin
                        state <= DISCONNECTED; // Disconnect signal received
                    end
                end
                
                DISCONNECTED: begin
                    if (connect) begin
                        state <= CONNECTED; // Connect signal received
                    end else if (reset) begin
                        state <= IDLE; // Reset to IDLE
                    end
                end
                
                default: state <= IDLE; // Default state
            endcase
        end
    end
endmodule