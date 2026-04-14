module dma_controller (
    input clk,
    input rst_n,
    input req1,
    input req2,
    output reg ack1,
    output reg ack2,
    input [7:0] src1,
    input [7:0] src2,
    output reg [7:0] dst1,
    output reg [7:0] dst2,
    output reg [7:0] data_out
);

    reg [1:0] channel_sel;
    reg transfer_complete;

    // State machine for channel selection and data transfer
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ack1 <= 0;
            ack2 <= 0;
            channel_sel <= 0;
            transfer_complete <= 0;
            data_out <= 8'b0;
        end else begin
            // Handle channel selection based on requests
            if (req1 && !ack1) begin
                channel_sel <= 2'b00; // Select channel 1
                ack1 <= 1; // Acknowledge channel 1
                transfer_complete <= 0; // Reset transfer complete flag
            end else if (req2 && !ack2) begin
                channel_sel <= 2'b01; // Select channel 2
                ack2 <= 1; // Acknowledge channel 2
                transfer_complete <= 0; // Reset transfer complete flag
            end
            
            // Data transfer simulation
            if (ack1 || ack2) begin
                if (channel_sel == 2'b00) begin
                    data_out <= src1; // Transfer data from channel 1
                    dst1 <= src1; // Simulate transfer complete
                    transfer_complete <= 1;
                end else if (channel_sel == 2'b01) begin
                    data_out <= src2; // Transfer data from channel 2
                    dst2 <= src2; // Simulate transfer complete
                    transfer_complete <= 1;
                end
            end

            // Reset acknowledgments after transfer complete
            if (transfer_complete) begin
                if (channel_sel == 2'b00) begin
                    ack1 <= 0; // Reset ack1
                end else if (channel_sel == 2'b01) begin
                    ack2 <= 0; // Reset ack2
                end
            end
        end
    end
endmodule