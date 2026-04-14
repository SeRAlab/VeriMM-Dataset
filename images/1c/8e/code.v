module dma_controller (
    input clk,
    input reset,
    input [3:0] req,
    output reg [3:0] gnt,
    output reg mem_write,
    output reg [7:0] data_out
);
    reg [1:0] current_channel;
    reg [1:0] next_channel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_channel <= 2'b00;
            gnt <= 4'b0000;
            mem_write <= 0;
            data_out <= 8'b00000000;
        end else begin
            gnt <= 4'b0000; // Clear grants
            if (req != 4'b0000) begin
                gnt[current_channel] <= 1'b1; // Grant current channel
                mem_write <= 1'b1; // Signal memory write
                data_out <= {4'b0000, current_channel}; // Simulate data transfer
                next_channel <= (current_channel + 1) % 4; // Round-robin next channel
            end else begin
                mem_write <= 0; // No memory write if no request
            end
            current_channel <= next_channel;
        end
    end
endmodule