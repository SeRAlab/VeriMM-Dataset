module pcie_endpoint_controller (
    input wire clk,
    input wire rst,
    input wire read,
    input wire write,
    input wire [3:0] addr,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:15]; // 16 x 8-bit memory

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 8'b0; // Reset output data
        end else begin
            if (write) begin
                memory[addr] <= data_in; // Write data to memory
            end
            if (read) begin
                data_out <= memory[addr]; // Read data from memory
            end
        end
    end
endmodule