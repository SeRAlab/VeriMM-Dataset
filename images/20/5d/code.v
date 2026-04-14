module dma_controller (
    input wire clk,
    input wire reset,
    input wire [1:0] channel_select,
    input wire start,
    output reg busy,
    output reg [1:0] selected_channel
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy <= 0;
            selected_channel <= 2'b00;
        end else if (start && !busy) begin
            busy <= 1;
            selected_channel <= channel_select;
        end else if (busy) begin
            // Simulate the transfer completion
            busy <= 0; // In a real design, this would be controlled by some completion logic
        end
    end
endmodule