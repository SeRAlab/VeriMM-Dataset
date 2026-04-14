module state_machine (
    input clk,
    input reset,
    input start,
    input stop,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00, RUNNING = 2'b01, DONE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else begin
            case (state)
                IDLE: if (start) state <= RUNNING;
                RUNNING: if (stop) state <= DONE;
                DONE: state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end
endmodule