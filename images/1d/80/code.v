module bluetooth_fsm(
    input clk,
    input reset,
    input start,
    input ack,
    input drop,
    output reg [1:0] state
);
    
    // State encoding
    localparam IDLE = 2'b00;
    localparam CONNECTING = 2'b01;
    localparam CONNECTED = 2'b10;
    localparam DISCONNECTED = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= CONNECTING;
                end
                CONNECTING: begin
                    if (ack) state <= CONNECTED;
                end
                CONNECTED: begin
                    if (drop) state <= DISCONNECTED;
                end
                DISCONNECTED: begin
                    if (reset) state <= IDLE;
                end
            endcase
        end
    end
endmodule