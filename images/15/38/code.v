module pcie_fsm (
    input wire clk,
    input wire rst,
    input wire req,
    input wire ack,
    output reg [1:0] state // 00: Idle, 01: Request, 10: Acknowledge
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter REQUEST = 2'b01;
    parameter ACKNOWLEDGE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (req) state <= REQUEST;
                end
                REQUEST: begin
                    if (ack) state <= ACKNOWLEDGE;
                end
                ACKNOWLEDGE: begin
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule