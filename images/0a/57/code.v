module sd_card_fsm (
    input wire clk,
    input wire reset,
    input wire start,
    input wire rw, // 0 for READ, 1 for WRITE
    output reg [1:0] state // 0: IDLE, 1: READ, 2: WRITE
);
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        if (rw)
                            state <= WRITE;
                        else
                            state <= READ;
                    end
                end
                READ: begin
                    state <= IDLE; // After read, go back to IDLE
                end
                WRITE: begin
                    state <= IDLE; // After write, go back to IDLE
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule