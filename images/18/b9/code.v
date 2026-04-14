module memory_controller (
    input clk,
    input reset,
    input [1:0] operation, // 00: free, 01: allocate
    input [3:0] address, // 4-bit address for a memory location
    output reg status // 0: free, 1: allocated
);
    reg [15:0] memory; // A simple memory array of 16 bits

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 16'b0; // Initialize memory to free
            status <= 0;
        end else begin
            case (operation)
                2'b00: begin // Free operation
                    memory[address] <= 1'b0; // Set memory location to free
                    status <= 0; // Output status free
                end
                2'b01: begin // Allocate operation
                    memory[address] <= 1'b1; // Set memory location to allocated
                    status <= 1; // Output status allocated
                end
            endcase
        end
    end
endmodule