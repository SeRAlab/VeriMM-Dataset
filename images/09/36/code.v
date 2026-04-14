module dma_controller (
    input wire clk,
    input wire reset,
    input wire start_transfer,
    input wire [2:0] channel_select,
    input wire [7:0] data_in,
    output reg [7:0] status_out,
    output reg ready
);
    
    reg [7:0] channel_status;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            channel_status <= 8'b00000000;
            status_out <= 8'b00000000;
            ready <= 1'b1;
        end else begin
            if (start_transfer && ready) begin
                channel_status[channel_select] <= 1'b1; // Set the selected channel active
                status_out <= channel_status; // Output the current status
                ready <= 1'b0; // Not ready for next transfer until done
            end
            if (~start_transfer) begin
                channel_status[channel_select] <= 1'b0; // Reset the selected channel
                ready <= 1'b1; // Ready for next transfer
            end
        end
    end
endmodule