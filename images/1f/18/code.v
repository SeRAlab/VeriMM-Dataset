module sd_card_fsm (
    input wire clk,
    input wire reset,
    input wire start,
    input wire read_complete,
    input wire write_complete,
    input wire error,
    output reg [1:0] state // 00: IDLE, 01: READ, 10: WRITE, 11: ERROR
);

    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10, ERROR = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= (start && !read_complete) ? READ : WRITE;
                    end
                end
                READ: begin
                    if (read_complete) begin
                        state <= IDLE;
                    end else if (error) begin
                        state <= ERROR;
                    end
                end
                WRITE: begin
                    if (write_complete) begin
                        state <= IDLE;
                    end else if (error) begin
                        state <= ERROR;
                    end
                end
                ERROR: begin
                    if (reset) begin
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule