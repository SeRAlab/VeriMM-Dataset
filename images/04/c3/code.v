module dma_controller (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    input wire [7:0] data_in,
    input wire rw, // 1 for write, 0 for read
    output reg transfer_complete,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:255]; // 256 bytes of memory
    reg [7:0] current_src;
    reg [7:0] current_dest;
    reg state; // 0: idle, 1: transferring

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            transfer_complete <= 0;
            state <= 0;
        end else if (start && !state) begin
            current_src <= src_addr;
            current_dest <= dest_addr;
            state <= 1; // Start transferring
            transfer_complete <= 0;
        end else if (state) begin
            if (rw) begin // Write operation
                memory[current_dest] <= data_in;
            end else begin // Read operation
                data_out <= memory[current_src];
            end
            state <= 0; // Transfer complete
            transfer_complete <= 1;
        end
    end
endmodule