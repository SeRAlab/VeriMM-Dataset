module bluetooth_fsm(
    input clk,
    input reset,
    input start,
    input stop,
    output reg [1:0] state
);

    parameter IDLE = 2'b00, CONNECT = 2'b01, DISCONNECT = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= CONNECT;
                CONNECT: if (stop) state <= DISCONNECT;
                DISCONNECT: if (start) state <= CONNECT; // For demonstration purposes
                default: state <= IDLE;
            endcase
        end
    end
endmodule