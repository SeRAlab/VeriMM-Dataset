module nvme_controller (
    input wire clk,
    input wire reset,
    input wire start_read,
    input wire start_write,
    input wire complete,
    output reg [1:0] state // 00: IDLE, 01: READ, 10: WRITE
);

    // State Encoding
    parameter IDLE = 2'b00;
    parameter READ = 2'b01;
    parameter WRITE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_read) begin
                        state <= READ;
                    end else if (start_write) begin
                        state <= WRITE;
                    end
                end
                READ: begin
                    if (complete) begin
                        state <= IDLE;
                    end
                end
                WRITE: begin
                    if (complete) begin
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule