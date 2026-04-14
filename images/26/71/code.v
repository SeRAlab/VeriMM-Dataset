module pcie_fsm (
    input wire clk,
    input wire rst,
    input wire start,
    input wire ack,
    output reg [1:0] state
);
    parameter IDLE = 2'b00;
    parameter REQUEST = 2'b01;
    parameter RESPONSE = 2'b10;
    parameter RESPONSE_DELAY = 3; // Number of clock cycles to stay in RESPONSE state

    reg [1:0] next_state;
    reg [1:0] response_counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            response_counter <= 0;
        end else begin
            state <= next_state;
            if (state == RESPONSE) begin
                if (response_counter < RESPONSE_DELAY)
                    response_counter <= response_counter + 1;
                else
                    response_counter <= 0; // Reset counter after delay
            end
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (start) 
                    next_state = REQUEST;
                else 
                    next_state = IDLE;
            end
            REQUEST: begin
                if (ack) 
                    next_state = RESPONSE;
                else 
                    next_state = REQUEST;
            end
            RESPONSE: begin
                if (response_counter == RESPONSE_DELAY)
                    next_state = IDLE;
                else 
                    next_state = RESPONSE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule