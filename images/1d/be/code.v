module ethernet_mac_controller(
    input clk,
    input reset,
    input start_receive,
    input start_transmit,
    input error,
    output reg [1:0] current_state
);
    // Define states
    parameter IDLE = 2'b00;
    parameter RECEIVE = 2'b01;
    parameter TRANSMIT = 2'b10;
    parameter ERROR_STATE = 2'b11;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            case (current_state)
                IDLE: begin
                    if (start_receive) begin
                        current_state <= RECEIVE;
                    end else if (start_transmit) begin
                        current_state <= TRANSMIT;
                    end
                end
                RECEIVE: begin
                    if (error) begin
                        current_state <= ERROR_STATE;
                    end else begin
                        current_state <= IDLE; // Assume receive completes
                    end
                end
                TRANSMIT: begin
                    if (error) begin
                        current_state <= ERROR_STATE;
                    end else begin
                        current_state <= IDLE; // Assume transmit completes
                    end
                end
                ERROR_STATE: begin
                    if (!error) begin
                        current_state <= IDLE; // Reset on error clear
                    end
                end
                default: current_state <= IDLE;
            endcase
        end
    end
endmodule