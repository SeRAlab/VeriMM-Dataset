module dma_controller (
    input clk,
    input rst,
    input start,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    input [7:0] mem_data,
    output reg dma_busy,
    output reg transfer_complete,
    output reg [7:0] data_out
);
    reg [3:0] state;
    parameter IDLE = 4'b0000, READ = 4'b0001, WRITE = 4'b0010, COMPLETE = 4'b0011;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            dma_busy <= 0;
            transfer_complete <= 0;
            data_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        dma_busy <= 1;
                        state <= READ;
                    end
                end
                READ: begin
                    data_out <= mem_data; // Assume mem_data is available
                    state <= WRITE;
                end
                WRITE: begin
                    // Simulate a write operation (for example's sake)
                    state <= COMPLETE;
                end
                COMPLETE: begin
                    transfer_complete <= 1;
                    dma_busy <= 0;
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule