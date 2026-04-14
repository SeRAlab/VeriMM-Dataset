module dma_controller(
    input clk,
    input rst,
    input valid_transfer,
    input [7:0] src_addr,
    input [7:0] dst_addr,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg ack
);
    reg [7:0] current_src_addr;
    reg [7:0] current_dst_addr;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_src_addr <= 8'b0;
            current_dst_addr <= 8'b0;
            data_out <= 8'b0;
            ack <= 0;
        end else if (valid_transfer) begin
            current_src_addr <= src_addr;
            current_dst_addr <= dst_addr;
            data_out <= data_in; // Simulate data transfer
            ack <= 1; // Acknowledge transfer
        end else begin
            ack <= 0; // No transfer
        end
    end
endmodule