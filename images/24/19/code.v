module nvme_controller(
    input clk,
    input rst,
    input start,
    input init_done,
    output reg [1:0] state // 00: IDLE, 01: INIT, 10: READ
);
    
    // State encoding
    parameter IDLE = 2'b00;
    parameter INIT = 2'b01;
    parameter READ = 2'b10;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= INIT;
                    end
                end
                INIT: begin
                    if (init_done) begin
                        state <= READ;
                    end
                end
                READ: begin
                    // Remain in READ state (for this simple example)
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule