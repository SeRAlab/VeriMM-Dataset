module nvme_controller (
    input clk,
    input rst,
    input req,
    input rw,
    output reg [1:0] state, // 00: IDLE, 01: READ, 10: WRITE
    output reg done
);

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
                    done <= 0;
                    if (req) begin
                        if (rw) begin
                            state <= READ;
                        end else begin
                            state <= WRITE;
                        end
                    end
                end
                READ: begin
                    // Simulate read operation here
                    state <= IDLE;
                    done <= 1; // Assume operation completes instantly
                end
                WRITE: begin
                    // Simulate write operation here
                    state <= IDLE;
                    done <= 1; // Assume operation completes instantly
                end
            endcase
        end
    end
endmodule