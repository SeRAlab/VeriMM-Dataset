module bluetooth_fsm (
    input wire clk,
    input wire reset,
    input wire start_scan,
    input wire connect,
    input wire disconnect,
    output reg [1:0] state
);

    // State encoding
    localparam IDLE = 2'b00, SCANNING = 2'b01, CONNECTED = 2'b10, DISCONNECTED = 2'b11;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_scan) state <= SCANNING;
                end
                SCANNING: begin
                    if (connect) state <= CONNECTED;
                end
                CONNECTED: begin
                    if (disconnect) state <= DISCONNECTED;
                end
                DISCONNECTED: begin
                    state <= IDLE; // Automatically return to IDLE
                end
            endcase
        end
    end
endmodule