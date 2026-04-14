module dma_controller (
    input clk,
    input reset,
    input req0,
    input req1,
    output reg ack0,
    output reg ack1,
    output reg [1:0] current_channel
);
    
    // State encoding
    parameter IDLE = 2'b00, CH0 = 2'b01, CH1 = 2'b10;

    reg [1:0] state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        // Default assignments
        next_state = state;
        ack0 = 0;
        ack1 = 0;
        
        case (state)
            IDLE: begin
                if (req0) begin
                    next_state = CH0;
                end else if (req1) begin
                    next_state = CH1;
                end
            end
            
            CH0: begin
                ack0 = 1; // Acknowledge channel 0
                if (!req0) begin
                    next_state = IDLE; // Go back to idle if no request
                end
            end
            
            CH1: begin
                ack1 = 1; // Acknowledge channel 1
                if (!req1) begin
                    next_state = IDLE; // Go back to idle if no request
                end
            end
        endcase
    end
    
    always @(state) begin
        case (state)
            IDLE: current_channel = 2'b00;
            CH0: current_channel = 2'b01;
            CH1: current_channel = 2'b10;
        endcase
    end
endmodule