module dma_controller (
    input wire start,
    input wire clk,
    input wire reset,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);

    reg [7:0] current_src_addr;
    reg [7:0] current_dest_addr;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 16'b0;
            current_src_addr <= 8'b0;
            current_dest_addr <= 8'b0;
        end else if (start) begin
            current_src_addr <= src_addr;
            current_dest_addr <= dest_addr;
            data_out <= data_in; // Simulate data transfer
        end
    end
endmodule