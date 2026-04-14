module pcie_sm (
    input wire clk,
    input wire reset,
    input wire start,
    input wire completion,
    output reg [1:0] state // 00: IDLE, 01: TRANSMIT, 10: RECEIVE
);

    parameter IDLE = 2'b00, TRANSMIT = 2'b01, RECEIVE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= TRANSMIT;
                TRANSMIT: if (completion) state <= RECEIVE;
                RECEIVE: state <= IDLE; // Return to IDLE for simplicity
                default: state <= IDLE;
            endcase
        end
    end
endmodule