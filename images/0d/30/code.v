module pcie_endpoint_controller (
    input wire clk,
    input wire reset,
    input wire start,
    output reg [1:0] state // 00: IDLE, 01: TRANSMIT, 10: RECEIVE
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter TRANSMIT = 2'b01;
    parameter RECEIVE = 2'b10;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= TRANSMIT;
                end
                TRANSMIT: begin
                    // Assume transmission takes one clock cycle
                    state <= RECEIVE;
                end
                RECEIVE: begin
                    // Return to IDLE after receiving
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule