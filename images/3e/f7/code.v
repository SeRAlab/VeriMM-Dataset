module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    input wire [15:0] data_in,
    output reg [15:0] data_out,
    output reg done
);

    reg [7:0] current_addr;
    reg transferring;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 16'b0;
            done <= 1'b0;
            transferring <= 1'b0;
            current_addr <= 8'b0;
        end else begin
            if (start && !transferring) begin
                transferring <= 1'b1;
                current_addr <= src_addr; // Start from source address
            end

            if (transferring) begin
                data_out <= data_in; // Transfer data
                // Simulate writing back to destination address (not shown here)
                done <= 1'b1; // Indicate transfer is done
                transferring <= 1'b0; // Reset for the next operation
            end
        end
    end
endmodule