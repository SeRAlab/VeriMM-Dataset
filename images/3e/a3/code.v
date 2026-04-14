module wifi_controller (
    input wire clk,
    input wire connect,
    input wire disconnect,
    output reg [1:0] state
);

    // State encoding
    localparam DISCONNECTED = 2'b00;
    localparam CONNECTING = 2'b01;
    localparam CONNECTED = 2'b10;
    localparam DISCONNECTING = 2'b11;

    always @(posedge clk) begin
        case (state)
            DISCONNECTED: begin
                if (connect) begin
                    state <= CONNECTING;
                end else begin
                    state <= DISCONNECTED;
                end
            end
            CONNECTING: begin
                state <= CONNECTED;
            end
            CONNECTED: begin
                if (disconnect) begin
                    state <= DISCONNECTING;
                end else begin
                    state <= CONNECTED;
                end
            end
            DISCONNECTING: begin
                state <= DISCONNECTED;
            end
            default: state <= DISCONNECTED;
        endcase
    end

    initial begin
        state = DISCONNECTED; // Start in the DISCONNECTED state
    end
endmodule