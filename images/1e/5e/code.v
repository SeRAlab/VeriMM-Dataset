module dma_controller (
    input clk,
    input reset,
    input [7:0] src_addr_ch1,
    input [7:0] dest_addr_ch1,
    input start_ch1,
    input [7:0] src_addr_ch2,
    input [7:0] dest_addr_ch2,
    input start_ch2,
    output reg done_ch1,
    output reg done_ch2
);
    reg [7:0] data_ch1;
    reg [7:0] data_ch2;
    reg transferring_ch1;
    reg transferring_ch2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            done_ch1 <= 0;
            done_ch2 <= 0;
            transferring_ch1 <= 0;
            transferring_ch2 <= 0;
        end else begin
            if (start_ch1 && !transferring_ch1) begin
                data_ch1 <= src_addr_ch1; // Simulate data read
                transferring_ch1 <= 1;
            end
            
            if (transferring_ch1) begin
                // Simulate data transfer
                done_ch1 <= 1;
                transferring_ch1 <= 0;
            end else begin
                done_ch1 <= 0;
            end

            if (start_ch2 && !transferring_ch2) begin
                data_ch2 <= src_addr_ch2; // Simulate data read
                transferring_ch2 <= 1;
            end
            
            if (transferring_ch2) begin
                // Simulate data transfer
                done_ch2 <= 1;
                transferring_ch2 <= 0;
            end else begin
                done_ch2 <= 0;
            end
        end
    end
endmodule