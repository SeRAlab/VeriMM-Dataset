module dma_controller (
    input wire clk,
    input wire enable,
    input wire [2:0] channel_select,
    output reg transfer_done
);
    reg [2:0] current_channel;

    always @(posedge clk) begin
        if (enable) begin
            current_channel <= channel_select;
            // Simulating data transfer with a delay
            transfer_done <= 0; // Transfer starts
            #10 transfer_done <= 1; // Transfer done after 10 time units
        end
    end
endmodule