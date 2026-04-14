module wifi_fsm (
    input wire clk,
    input wire reset,
    input wire start_scan,
    input wire connect,
    input wire disconnect,
    output reg [1:0] state // 00: IDLE, 01: SCAN, 10: CONNECT, 11: DISCONNECT
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter SCAN = 2'b01;
    parameter CONNECT = 2'b10;
    parameter DISCONNECT = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_scan) state <= SCAN;
                end
                SCAN: begin
                    if (connect) state <= CONNECT;
                end
                CONNECT: begin
                    if (disconnect) state <= DISCONNECT;
                end
                DISCONNECT: begin
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule