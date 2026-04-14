module dma_controller (
    input clk,
    input reset,
    input start,
    input [7:0] source_address,
    input [7:0] destination_address,
    input [7:0] bytes_to_transfer,
    output reg transfer_complete,
    output reg [7:0] current_address
);
    reg [7:0] remaining_bytes;
    reg [7:0] src_addr;
    reg [7:0] dest_addr;
    reg transferring;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            transfer_complete <= 0;
            current_address <= 0;
            remaining_bytes <= 0;
            transferring <= 0;
        end else if (start && !transferring) begin
            src_addr <= source_address;
            dest_addr <= destination_address;
            remaining_bytes <= bytes_to_transfer;
            current_address <= src_addr;
            transferring <= 1;
            transfer_complete <= 0;
        end else if (transferring) begin
            if (remaining_bytes > 0) begin
                // Simulate data transfer
                current_address <= current_address + 1;
                remaining_bytes <= remaining_bytes - 1;
            end else begin
                transferring <= 0;
                transfer_complete <= 1;
            end
        end
    end
endmodule