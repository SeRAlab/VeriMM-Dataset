module sd_card_fsm (
    input clk,
    input reset,
    input start,
    output reg [1:0] state
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
                IDLE: if (start) state <= READ;
                READ: if (start) state <= WRITE; else state <= IDLE;
                WRITE: if (start) state <= IDLE; else state <= READ;
                default: state <= IDLE;
            endcase
        end
    end
endmodule