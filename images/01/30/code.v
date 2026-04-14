module sd_card_interface (
    input clk,
    input reset,
    input start,
    input rw, // 0 for READ, 1 for WRITE
    output reg [1:0] state // 00 for IDLE, 01 for READ, 10 for WRITE
);

    // State encoding
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= rw ? WRITE : READ;
                    end
                end
                READ: begin
                    if (start) begin
                        state <= IDLE;
                    end
                end
                WRITE: begin
                    if (start) begin
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule