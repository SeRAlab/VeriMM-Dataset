module dma_controller(
    input clk,
    input rst,
    input [3:0] req, // Request lines from 4 channels
    output reg [1:0] sel, // Selected channel
    output reg ack // Acknowledge signal
);
    reg [1:0] state, next_state;

    // State encoding
    localparam IDLE    = 2'b00;
    localparam CH0     = 2'b01;
    localparam CH1     = 2'b10;
    localparam CH2     = 2'b11;
    
    // State transition
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                ack = 0;
                if (req[0]) next_state = CH0;
                else if (req[1]) next_state = CH1;
                else if (req[2]) next_state = CH2;
                else next_state = IDLE;
            end
            CH0: begin
                ack = 1;
                sel = 2'b00;
                next_state = IDLE;
            end
            CH1: begin
                ack = 1;
                sel = 2'b01;
                next_state = IDLE;
            end
            CH2: begin
                ack = 1;
                sel = 2'b10;
                next_state = IDLE;
            end
            default: begin
                ack = 0;
                sel = 2'b00;
                next_state = IDLE;
            end
        endcase
    end
endmodule