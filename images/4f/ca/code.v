module top_module(
    input clk,
    input [3:0] addr,
    input [7:0] data_in,
    input write_en,
    output reg [7:0] data_out
);reg [7:0] memory [0:15]; // Declare a simple memory array of 16 locations

    initial begin
        // Initialize memory with data
        memory[0] = 8'h00;
        memory[1] = 8'h11;
        memory[2] = 8'h22;
        memory[3] = 8'h33;
        memory[4] = 8'h44;
        memory[5] = 8'h55;
        memory[6] = 8'h66;
        memory[7] = 8'h77;
        memory[8] = 8'h88;
        memory[9] = 8'h99;
        memory[10] = 8'hAA;
        memory[11] = 8'hBB;
        memory[12] = 8'hCC;
        memory[13] = 8'hDD;
        memory[14] = 8'hEE;
        memory[15] = 8'hFF;
    end

    always @(posedge clk) begin
        if (write_en) begin
            memory[addr] <= data_in;  // Write data to memory
        end
        data_out <= memory[addr]; // Read data from memory
    end

endmodule