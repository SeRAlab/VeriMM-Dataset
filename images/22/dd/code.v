module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire start_receive,
    input wire start_transmit,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter RECEIVE = 2'b01;
    parameter TRANSMIT = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_receive)
                        state <= RECEIVE;
                    else if (start_transmit)
                        state <= TRANSMIT;
                end
                RECEIVE: begin
                    if (start_transmit)
                        state <= TRANSMIT;
                    else
                        state <= IDLE; // Back to IDLE after receive
                end
                TRANSMIT: begin
                    if (start_receive)
                        state <= RECEIVE;
                    else
                        state <= IDLE; // Back to IDLE after transmit
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule