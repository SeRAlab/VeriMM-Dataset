module bluetooth_manager(
    input wire clk,
    input wire reset,
    input wire start_scan,
    input wire connect,
    input wire confirm_connection,
    input wire disconnect,
    output reg [1:0] state // 00: IDLE, 01: SCANNING, 10: CONNECTING, 11: CONNECTED
);
    // State encoding
    localparam IDLE = 2'b00;
    localparam SCANNING = 2'b01;
    localparam CONNECTING = 2'b10;
    localparam CONNECTED = 2'b11;

    // Sequential logic for state transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_scan) state <= SCANNING;
                end
                SCANNING: begin
                    if (connect) state <= CONNECTING;
                end
                CONNECTING: begin
                    if (confirm_connection) state <= CONNECTED;
                end
                CONNECTED: begin
                    if (disconnect) state <= IDLE;
                end
            endcase
        end
    end
endmodule