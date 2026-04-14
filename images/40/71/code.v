module fsm (
    input clk,
    input reset,
    input start,
    output reg [1:0] state
);

    // State encoding
    parameter IDLE = 2'b00, WORKING = 2'b01, DONE = 2'b10;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; // Reset to IDLE state
        end else begin
            case (state)
                IDLE: if (start) state <= WORKING;
                WORKING: if (!start) state <= DONE;
                DONE: if (start) state <= IDLE;
                default: state <= IDLE; // Default case to handle unexpected states
            endcase
        end
    end
endmodule