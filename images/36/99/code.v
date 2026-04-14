module dma_controller (
    input clk,
    input start,
    input [3:0] count, // Number of transfers
    output reg done,
    output reg [7:0] src_address,
    output reg [7:0] dest_address,
    output reg [7:0] data_out
);

    reg [3:0] transfer_count;
    reg transferring;

    always @(posedge clk) begin
        if (start) begin
            transfer_count <= count;
            src_address <= 8'h00; // Starting address for source
            dest_address <= 8'hFF; // Starting address for destination
            transferring <= 1;
            done <= 0;
        end else if (transferring) begin
            if (transfer_count > 0) begin
                data_out <= src_address; // Simulate data transfer
                src_address <= src_address + 1; // Increment source address
                dest_address <= dest_address + 1; // Increment destination address
                transfer_count <= transfer_count - 1;
            end else begin
                transferring <= 0;
                done <= 1; // Transfer complete
            end
        end
    end
endmodule