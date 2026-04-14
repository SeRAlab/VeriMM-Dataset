module NVMe_Controller (
    input clk,
    input reset,
    input ctrl,
    output reg [1:0] state
);
    parameter IDLE = 2'b00;
    parameter READ = 2'b01;
    parameter WRITE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (ctrl) 
                        state <= WRITE;
                    else 
                        state <= READ;
                end
                READ: begin
                    state <= IDLE; // After read, go back to IDLE
                end
                WRITE: begin
                    state <= IDLE; // After write, go back to IDLE
                end
                default: state <= IDLE; // Fallback
            endcase
        end
    end
endmodule