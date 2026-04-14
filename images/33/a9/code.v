module dma_controller (
    input clk,
    input reset,
    input enable,
    input rw, // 0 = read, 1 = write
    input [7:0] src_addr,
    input [7:0] dest_addr,
    inout [7:0] data_bus
);
    reg [7:0] memory [0:255]; // 256 bytes of memory
    reg [7:0] data;

    assign data_bus = (rw == 0) ? memory[src_addr] : 8'bz; // tri-state for read
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Optional: reset logic if needed
        end else if (enable) begin
            if (rw == 1) begin
                memory[dest_addr] <= data_bus; // write
            end
        end
    end
endmodule