module bluetooth_controller (
    input clk,
    input rst,
    input start_scan,
    input connect,
    input disconnect,
    output reg [1:0] state // 00 - IDLE, 01 - SCANNING, 10 - CONNECTING, 11 - CONNECTED
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam SCANNING = 2'b01;
    localparam CONNECTING = 2'b10;
    localparam CONNECTED = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start_scan) state <= SCANNING;
                SCANNING: if (connect) state <= CONNECTING;
                CONNECTING: if (disconnect) state <= IDLE;
                CONNECTED: if (disconnect) state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end
endmodule