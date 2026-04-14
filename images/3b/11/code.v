module dma_controller (
    input clk,
    input rst_n,
    input start,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    input [7:0] data_in,
    input [3:0] bytes_to_transfer,
    output reg [7:0] data_out,
    output reg transfer_complete,
    output reg transferring
);

    reg [3:0] byte_count;
    reg [7:0] current_src_addr;
    reg [7:0] current_dest_addr;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            transfer_complete <= 1'b0;
            transferring <= 1'b0;
            byte_count <= 4'd0;
            data_out <= 8'd0;
        end else if (start && !transferring) begin
            current_src_addr <= src_addr;
            current_dest_addr <= dest_addr;
            byte_count <= bytes_to_transfer;
            transferring <= 1'b1;
            transfer_complete <= 1'b0;
        end else if (transferring) begin
            if (byte_count > 0) begin
                data_out <= data_in; // Simulate data transfer
                byte_count <= byte_count - 1;
                current_src_addr <= current_src_addr + 1;
                current_dest_addr <= current_dest_addr + 1;
            end else begin
                transferring <= 1'b0;
                transfer_complete <= 1'b1; // Transfer is complete
            end
        end
    end

endmodule