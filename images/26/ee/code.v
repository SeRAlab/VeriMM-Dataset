module PCIe_Controller (
    input clk,
    input reset,
    input start,
    input process,
    input done,
    output reg [1:0] state // 00: IDLE, 01: READY, 10: BUSY
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter READY = 2'b01;
    parameter BUSY = 2'b10;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= READY;
                READY: if (process) state <= BUSY;
                BUSY: if (done) state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end
endmodule