module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [2:0] channel_select,
    output reg done
);
    reg [2:0] current_channel;
    reg transferring;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            done <= 0;
            current_channel <= 0;
            transferring <= 0;
        end else if (start && !transferring) begin
            current_channel <= channel_select;
            transferring <= 1;
        end else if (transferring) begin
            // Simulate data transfer completion
            done <= 1; // Indicate transfer is done
            transferring <= 0; // Reset transferring state
        end
    end
endmodule