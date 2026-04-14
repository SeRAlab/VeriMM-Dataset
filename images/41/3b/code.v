module top_module(
    input clk,
    input [15:0] wdata,
    output reg [15:0] rdata,
    input [7:0] addr,
    input WE
);reg [15:0] memory [0:255]; // Define a memory array for 256 entries of 16 bits each

    // Write operation
    always @(posedge clk) begin
        if (WE) begin
            memory[addr] <= wdata; // Store data at the specified address
        end
        else begin
            rdata <= memory[addr]; // Read data from the specified address
        end
    end
    
    // Set initial values
    initial begin
        memory[0] = 16'h1234; // Example initialization
        memory[1] = 16'h5678; // Example initialization
        memory[2] = 16'h9ABC; // Example initialization
        // Initialize other memory elements as required
    end

endmodule