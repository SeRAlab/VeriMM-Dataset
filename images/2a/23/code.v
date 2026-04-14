module bluetooth_sm (
    input wire clk,
    input wire reset,
    input wire start_connection,
    input wire connection_success,
    output reg [1:0] state // 00: IDLE, 01: CONNECTING, 10: CONNECTED
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam CONNECTING = 2'b01;
    localparam CONNECTED = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_connection)
                        state <= CONNECTING;
                end
                CONNECTING: begin
                    if (connection_success)
                        state <= CONNECTED;
                end
                CONNECTED: begin
                    if (!start_connection)
                        state <= IDLE;
                end
            endcase
        end
    end
endmodule