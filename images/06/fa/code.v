module nvme_controller (
    input clk,
    input reset,
    input start,
    input done,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00,
              PROCESS = 2'b01,
              DONE = 2'b10;
    
    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= PROCESS;
                PROCESS: if (done) state <= DONE;
                DONE: state <= IDLE; // Automatically go back to IDLE
            endcase
        end
    end
endmodule