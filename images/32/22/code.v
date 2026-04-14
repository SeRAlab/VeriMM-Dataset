module sd_card_interface (
    input wire clk,
    input wire reset,
    input wire start_read,
    input wire start_write,
    input wire done,
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
                    if (start_read) state <= READ;
                    else if (start_write) state <= WRITE;
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