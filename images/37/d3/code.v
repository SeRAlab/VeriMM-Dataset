module sata_controller (
    input clk,
    input rst_n,
    input start_connect,
    input disconnect,
    output reg [1:0] state
);
    // State encoding
    localparam IDLE = 2'b00,
               CONNECTING = 2'b01,
               CONNECTED = 2'b10,
               DISCONNECTED = 2'b11;

    // State transition process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_connect) state <= CONNECTING;
                end
                CONNECTING: begin
                    state <= CONNECTED;
                end
                CONNECTED: begin
                    if (disconnect) state <= DISCONNECTED;
                end
                DISCONNECTED: begin
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule