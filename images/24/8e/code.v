module ethernet_mac_controller (
    input clk,
    input reset,
    input transmit_enable,
    input receive_enable,
    input done,
    output reg [1:0] state // 00: IDLE, 01: TRANSMIT, 10: RECEIVE
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter TRANSMIT = 2'b01;
    parameter RECEIVE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (transmit_enable) begin
                        state <= TRANSMIT;
                    end else if (receive_enable) begin
                        state <= RECEIVE;
                    end
                end
                TRANSMIT: begin
                    if (done) begin
                        state <= IDLE;
                    end
                end
                RECEIVE: begin
                    if (done) begin
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule