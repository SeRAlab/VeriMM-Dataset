module RRT_StateMachine (
    input clk,
    input reset,
    input sample_trigger,
    output reg [1:0] state // 00: IDLE, 01: SAMPLE, 10: GROW
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter SAMPLE = 2'b01;
    parameter GROW = 2'b10;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: 
                    if (sample_trigger) 
                        state <= SAMPLE;
                SAMPLE: 
                    state <= GROW;
                GROW: 
                    state <= IDLE;
                default: 
                    state <= IDLE;
            endcase
        end
    end
endmodule