module nvme_controller (
    input clk,
    input rst,
    input start,
    input cmd, // 0 for READ, 1 for WRITE
    output reg [1:0] state, // 00: IDLE, 01: READ, 10: WRITE
    output reg done
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter READ = 2'b01;
    parameter WRITE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        if (cmd) begin
                            state <= WRITE;
                        end else begin
                            state <= READ;
                        end
                    end
                    done <= 0;
                end
                READ: begin
                    // Simulate read operation
                    state <= IDLE;
                    done <= 1; // Operation complete
                end
                WRITE: begin
                    // Simulate write operation
                    state <= IDLE;
                    done <= 1; // Operation complete
                end
                default: state <= IDLE; // Default case
            endcase
        end
    end
endmodule