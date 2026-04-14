module ethernet_mac_controller (
    input clk,
    input reset,
    input start_transmit,
    input start_receive,
    input error_detected,
    output reg [1:0] state // 00: IDLE, 01: TRANSMIT, 10: RECEIVE, 11: ERROR
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter TRANSMIT = 2'b01;
    parameter RECEIVE = 2'b10;
    parameter ERROR = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_transmit) begin
                        state <= TRANSMIT;
                    end else if (start_receive) begin
                        state <= RECEIVE;
                    end
                end
                TRANSMIT: begin
                    if (error_detected) begin
                        state <= ERROR;
                    end else begin
                        state <= IDLE; // Assuming transmission ends
                    end
                end
                RECEIVE: begin
                    if (error_detected) begin
                        state <= ERROR;
                    end else begin
                        state <= IDLE; // Assuming reception ends
                    end
                end
                ERROR: begin
                    // Handle error state, transition back to IDLE
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule