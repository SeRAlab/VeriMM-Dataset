module dma_controller (
    input clk,
    input reset,
    input enable,
    input [7:0] src_addr,
    input [7:0] dest_addr,
    output reg busy,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:255]; // Simulated memory
    reg [7:0] data_in;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy <= 0;
            data_out <= 8'b0;
        end else if (enable) begin
            busy <= 1;
            data_in <= memory[src_addr]; // Read from source address
            data_out <= data_in;          // Write to destination address
            memory[dest_addr] <= data_out;
            busy <= 0;                     // Operation complete
        end
    end
endmodule