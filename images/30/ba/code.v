module deadbeat_controller (
    input clk,
    input reset,
    input [3:0] target,
    output reg [3:0] output_signal
);
    reg [1:0] state; // state variable
    parameter IDLE = 2'b00, SET = 2'b01, DONE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_signal <= 4'b0000;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    output_signal <= 4'b0000; // initialize output
                    state <= SET;
                end
                SET: begin
                    output_signal <= target; // set output to target
                    state <= DONE;
                end
                DONE: begin
                    // stay in done state
                end
            endcase
        end
    end
endmodule