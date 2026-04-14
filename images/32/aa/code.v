module bluetooth_module (
    input clk,
    input reset,
    input start_connect,
    input connection_success,
    output reg [1:0] state // 2 bits for 3 states (00: IDLE, 01: CONNECTING, 10: CONNECTED)
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
                    if (start_connect) begin
                        state <= CONNECTING;
                    end
                end
                CONNECTING: begin
                    if (connection_success) begin
                        state <= CONNECTED;
                    end
                end
                CONNECTED: begin
                    if (reset) begin
                        state <= IDLE; // Goes to IDLE if reset is asserted
                    end
                end
            endcase
        end
    end
endmodule