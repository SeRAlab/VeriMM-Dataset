module dma_controller (
    input clk,
    input reset,
    input start,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    input [3:0] transfer_length,
    output reg done,
    output reg [7:0] data_out,
    output reg [7:0] current_dest_addr
);
    
    reg [3:0] counter;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            done <= 0;
            counter <= 0;
            current_dest_addr <= 0;
        end else if (start) begin
            done <= 0;
            counter <= 0;
            current_dest_addr <= dest_addr;
        end else if (counter < transfer_length) begin
            // Simulate data transfer
            data_out <= src_addr + counter; // Example data
            current_dest_addr <= current_dest_addr + 1;
            counter <= counter + 1;
        end else begin
            done <= 1; // Transfer is complete
        end
    end
endmodule