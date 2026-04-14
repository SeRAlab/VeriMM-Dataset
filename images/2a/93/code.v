module dma_controller(
    input clk,
    input rst_n,
    input req_channel0,
    input req_channel1,
    output reg ack_channel0,
    output reg ack_channel1,
    output reg ready
);
    reg [1:0] current_state, next_state;
    
    localparam IDLE = 2'b00,
               CHANNEL0_ACTIVE = 2'b01,
               CHANNEL1_ACTIVE = 2'b10;
               
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end
    
    always @(*) begin
        next_state = current_state;
        ack_channel0 = 0;
        ack_channel1 = 0;
        ready = 1;
        
        case (current_state)
            IDLE: begin
                if (req_channel0) begin
                    next_state = CHANNEL0_ACTIVE;
                end else if (req_channel1) begin
                    next_state = CHANNEL1_ACTIVE;
                end
            end
            
            CHANNEL0_ACTIVE: begin
                ack_channel0 = 1;
                ready = 0;  // not ready while processing
                if (!req_channel0) begin
                    next_state = IDLE;
                end
            end
            
            CHANNEL1_ACTIVE: begin
                ack_channel1 = 1;
                ready = 0;  // not ready while processing
                if (!req_channel1) begin
                    next_state = IDLE;
                end
            end
        endcase
    end
endmodule