module dma_controller(
    input clk,
    input reset,
    input start,
    input [31:0] src_addr1,
    input [31:0] dst_addr1,
    input [31:0] src_addr2,
    input [31:0] dst_addr2,
    output reg channel_active,
    output reg transfer_done,
    output reg [31:0] data_transferred
);
    reg [1:0] state;
    reg [31:0] src_addr, dst_addr;

    // State encoding
    localparam IDLE = 2'b00, TRANSFER1 = 2'b01, TRANSFER2 = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            channel_active <= 0;
            transfer_done <= 0;
            data_transferred <= 32'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= TRANSFER1;
                        src_addr <= src_addr1;
                        dst_addr <= dst_addr1;
                        channel_active <= 1;
                    end
                end
                TRANSFER1: begin
                    data_transferred <= src_addr;  // Simulate data transfer
                    state <= TRANSFER2;
                    dst_addr <= dst_addr1;  // Keep the same destination for simplicity
                end
                TRANSFER2: begin
                    data_transferred <= src_addr2;  // Simulate data transfer for channel 2
                    channel_active <= 0;
                    transfer_done <= 1;
                    state <= IDLE;  // Return to IDLE after transfer
                end
            endcase
        end
    end
endmodule