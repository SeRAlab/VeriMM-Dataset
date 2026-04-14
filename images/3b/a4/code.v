module nvme_controller (
    input clk,
    input reset,
    input read_req,
    input write_req,
    output reg [1:0] state // 00: IDLE, 01: READ, 10: WRITE
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
                    if (read_req) state <= READ;
                    else if (write_req) state <= WRITE;
                end
                READ: begin
                    state <= IDLE; // Complete read operation
                end
                WRITE: begin
                    state <= IDLE; // Complete write operation
                end
            endcase
        end
    end
endmodule