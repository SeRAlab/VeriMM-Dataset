module pcie_endpoint_controller(
    input wire clk,
    input wire request, // 1 for write, 0 for read
    input wire [2:0] address, // 3-bit address (up to 8 locations)
    input wire [7:0] data_in, // data input for write operations
    output reg [7:0] data_out, // data output for read operations
    output reg done // operation complete signal
);

    reg [7:0] memory [0:7]; // Memory emulation of 8 locations
    reg state; // 0: idle, 1: busy
    
    always @(posedge clk) begin
        if (state == 0) begin
            done <= 0; // Not done in idle state
            if (request) begin // Write operation
                memory[address] <= data_in; // Store data
                state <= 1; // Move to busy state
            end else begin // Read operation
                data_out <= memory[address]; // Read data
                done <= 1; // Operation completed
            end
        end else begin
            done <= 1; // Operation is done
            state <= 0; // Go back to idle
        end
    end
endmodule