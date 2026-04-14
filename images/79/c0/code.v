module moore_fsm(
    input clk,
    input reset,
    input start,
    input stop,
    output reg [1:0] state);parameter IDLE = 2'b00, START = 2'b01, STOP = 2'b10;

always @(posedge clk)
    if (reset)
        state <= IDLE;
    else case (state)
        IDLE: if (start) state <= START;
        START: if (stop) state <= STOP;
        STOP: state <= IDLE;
        default: state <= IDLE;
    endcase
    
endmodule