module eth_mac_controller (
    input wire clk,
    input wire rst_n,
    input wire start_tx,
    input wire ack_received,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00;
    parameter TRANSMIT = 2'b01;
    parameter WAIT_FOR_ACK = 2'b10;

    // State register
    reg [1:0] next_state;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (start_tx) 
                    next_state = TRANSMIT;
                else 
                    next_state = IDLE;
            end
            TRANSMIT: begin
                next_state = WAIT_FOR_ACK; // Assume transmission is always complete
            end
            WAIT_FOR_ACK: begin
                if (ack_received) 
                    next_state = IDLE;
                else 
                    next_state = WAIT_FOR_ACK;
            end
            default: next_state = IDLE;
        endcase
    end

    // State update logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            state <= IDLE;
        else 
            state <= next_state;
    end
endmodule