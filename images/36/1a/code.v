module dma_controller(
    input wire clk,
    input wire reset,
    input wire start,
    input wire channel0,
    input wire channel1,
    input wire channel2,
    input wire channel3,
    output reg [1:0] current_channel
);

    reg [1:0] next_channel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_channel <= 2'b00;
        end else if (start) begin
            current_channel <= next_channel;
        end
    end

    always @(*) begin
        case (current_channel)
            2'b00: next_channel = channel1 ? 2'b01 : (channel2 ? 2'b10 : (channel3 ? 2'b11 : 2'b00));
            2'b01: next_channel = channel2 ? 2'b10 : (channel3 ? 2'b11 : (channel0 ? 2'b00 : 2'b01));
            2'b10: next_channel = channel3 ? 2'b11 : (channel0 ? 2'b00 : (channel1 ? 2'b01 : 2'b10));
            2'b11: next_channel = channel0 ? 2'b00 : (channel1 ? 2'b01 : (channel2 ? 2'b10 : 2'b11));
            default: next_channel = 2'b00;
        endcase
    end
endmodule