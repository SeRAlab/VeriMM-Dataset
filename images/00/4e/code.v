module dma_controller(
    input clk,
    input reset,
    input [7:0] src_addr1,
    input [7:0] dest_addr1,
    input [7:0] src_addr2,
    input [7:0] dest_addr2,
    input control, // 0 for channel 1, 1 for channel 2
    output reg [7:0] data_out
);

reg [7:0] memory [0:255]; // Simple memory array for demonstration
reg [7:0] src_addr, dest_addr;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= 8'b0;
    end else begin
        if (control == 0) begin
            // Channel 1 transfer
            src_addr <= src_addr1;
            dest_addr <= dest_addr1;
        end else begin
            // Channel 2 transfer
            src_addr <= src_addr2;
            dest_addr <= dest_addr2;
        end
        // Perform the data transfer
        data_out <= memory[src_addr]; // Simulating a memory read
        memory[dest_addr] <= data_out; // Simulating a memory write
    end
end

endmodule