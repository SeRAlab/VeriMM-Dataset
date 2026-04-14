module dma_controller(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    input wire [7:0] data_in,
    input wire [3:0] num_transfers,
    output reg [7:0] data_out,
    output reg done
);

    reg [3:0] transfer_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            transfer_count <= 0;
            data_out <= 0;
            done <= 0;
        end else if (start && (transfer_count < num_transfers)) begin
            data_out <= data_in; // Simulate transfer of data
            transfer_count <= transfer_count + 1;
            if (transfer_count + 1 == num_transfers) begin
                done <= 1; // Indicate transfer is complete
            end else begin
                done <= 0;
            end
        end
    end
endmodule