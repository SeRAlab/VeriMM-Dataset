module dma_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] request, // 4 request lines for 4 channels
    output reg [1:0] active_channel // 2-bit output to indicate active channel
);
    reg [1:0] state;
    reg [1:0] next_state;

    // Parameter definitions for states
    parameter IDLE = 2'b00, CH0 = 2'b01, CH1 = 2'b10, CH2 = 2'b11, CH3 = 2'b100;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (request[0]) next_state = CH0;
                else if (request[1]) next_state = CH1;
                else if (request[2]) next_state = CH2;
                else if (request[3]) next_state = CH3;
                else next_state = IDLE;
            end
            CH0: next_state = IDLE; // Complete service for CH0
            CH1: next_state = IDLE; // Complete service for CH1
            CH2: next_state = IDLE; // Complete service for CH2
            CH3: next_state = IDLE; // Complete service for CH3
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        case (state)
            CH0: active_channel <= 2'b00;
            CH1: active_channel <= 2'b01;
            CH2: active_channel <= 2'b10;
            CH3: active_channel <= 2'b11;
            default: active_channel <= 2'b00;
        endcase
    end
endmodule