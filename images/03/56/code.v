module dma_controller(
    input clk,
    input reset,
    input start,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    input [3:0] data_size,
    output reg transfer_done,
    output reg [7:0] data_out
);
    reg [3:0] counter;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            transfer_done <= 0;
            counter <= 0;
            data_out <= 0;
        end else if (start) begin
            if (counter < data_size) begin
                data_out <= src_addr + counter; // Mock data transfer
                counter <= counter + 1;
                transfer_done <= 0;
            end else begin
                transfer_done <= 1;
                counter <= 0; // Reset counter for next transfer
            end
        end
    end
endmodule