module sata_controller (
    input clk,
    input reset,
    input start,
    output reg [1:0] state // 00: IDLE, 01: TRANSMIT, 10: RECEIVE
);
    // State encoding
    localparam IDLE = 2'b00;
    localparam TRANSMIT = 2'b01;
    localparam RECEIVE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= TRANSMIT;
                TRANSMIT: state <= RECEIVE;
                RECEIVE: state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end
endmodule