module state_machine (
    input clk,
    input reset,
    input start,
    input complete,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter WORK = 2'b01;
    parameter DONE = 2'b10;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= WORK;
                WORK: if (complete) state <= DONE;
                DONE: state <= IDLE; // Automatically return to IDLE
                default: state <= IDLE; // Default case to avoid latches
            endcase
        end
    end
endmodule