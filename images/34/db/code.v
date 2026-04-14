module pci_endpoint_controller (
    input clk,
    input reset,
    input request,
    input write,
    input [31:0] address,
    input [31:0] data_in,
    output reg [31:0] data_out,
    output reg ready
);
    reg [31:0] memory [0:255]; // Simple memory array
    reg processing;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ready <= 1;
            processing <= 0;
            data_out <= 32'b0;
        end else if (request && ready) begin
            ready <= 0;
            processing <= 1;

            if (write) begin
                memory[address[7:0]] <= data_in; // Store data in memory
            end else begin
                data_out <= memory[address[7:0]]; // Read data from memory
            end
            
            processing <= 0;
            ready <= 1; // Set ready for the next request
        end
    end
endmodule