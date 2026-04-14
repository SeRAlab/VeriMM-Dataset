module robot_navigation (
    input clk,
    input reset,
    input start,
    input stop,
    input move,
    output reg [1:0] state
);

    // State encoding
    parameter IDLE = 2'b00, MOVING = 2'b01, STOP = 2'b10;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) 
                        state <= MOVING;
                end
                MOVING: begin
                    if (stop) 
                        state <= STOP;
                end
                STOP: begin
                    if (start) 
                        state <= MOVING;
                end
            endcase
        end
    end
endmodule