module bluetooth_fsm (
    input clk,
    input reset,
    input start,
    output reg [1:0] state
);
    // State encoding
    localparam IDLE = 2'b00;
    localparam CONNECTING = 2'b01;
    localparam CONNECTED = 2'b10;

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= CONNECTING;
                    end
                end
                CONNECTING: begin
                    state <= CONNECTED; // Assume connection is immediate for this problem
                end
                CONNECTED: begin
                    if (reset) begin
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule