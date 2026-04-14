module dma_controller(
    input clk,
    input reset,
    input start,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    output reg [7:0] data_out,
    output reg busy
);
    reg [7:0] memory [255:0]; // Simple memory representation
    reg [7:0] data_in;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy <= 0;
            data_out <= 8'b0;
        end else if (start && !busy) begin
            busy <= 1;
            data_in = memory[src_addr]; // Read data from source address
            data_out = data_in; // Transfer data to output
            memory[dest_addr] = data_out; // Write data to destination address
            busy <= 0; // Transfer complete
        end
    end
endmodule