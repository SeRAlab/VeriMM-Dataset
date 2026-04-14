module ethernet_mac_controller (
    input clk,
    input reset,
    input start_receive,
    input start_transmit,
    output reg [1:0] state
);

    parameter IDLE = 2'b00, 
              RECEIVE = 2'b01, 
              TRANSMIT = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) 
            state <= IDLE;
        else begin
            case (state)
                IDLE: begin
                    if (start_receive)
                        state <= RECEIVE;
                    else if (start_transmit)
                        state <= TRANSMIT;
                end
                RECEIVE: begin
                    // Here you might want to add a condition to return to IDLE or continue receiving
                    state <= IDLE; // For simplicity, we return to IDLE after receiving
                end
                TRANSMIT: begin
                    // Here you might want to add a condition to return to IDLE or continue transmitting
                    state <= IDLE; // For simplicity, we return to IDLE after transmitting
                end
            endcase
        end
    end
endmodule