module dma_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [1:0] channel,
    input wire [7:0] read_data,
    input wire ack,
    output reg transfer_complete,
    output reg [7:0] write_data
);

    reg [1:0] current_channel;
    reg transferring;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_channel <= 2'b00;
            transferring <= 1'b0;
            transfer_complete <= 1'b0;
            write_data <= 8'b0;
        end else begin
            if (start) begin
                current_channel <= channel;
                transferring <= 1'b1;
                write_data <= read_data;  // Prepare data to be written
            end

            if (transferring && ack) begin
                transfer_complete <= 1'b1; // Transfer complete signal
                transferring <= 1'b0; // End transfer
            end else begin
                transfer_complete <= 1'b0; // Reset transfer complete signal
            end
        end
    end
endmodule