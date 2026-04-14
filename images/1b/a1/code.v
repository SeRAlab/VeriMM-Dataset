module NVMe_Controller (
    input clk,
    input reset,
    input start,
    input done,
    output reg [1:0] state // 2'b00 for IDLE, 2'b01 for READ, 2'b10 for WRITE
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter READ = 2'b01;
    parameter WRITE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= (done) ? IDLE : READ;
                end
                READ: begin
                    if (done) state <= IDLE;
                end
                WRITE: begin
                    if (done) state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule