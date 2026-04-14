module SRAM_4bit (
    input wire [3:0] data_in,
    input wire [1:0] addr,
    input wire rw,  // read/write control signal
    output reg [3:0] data_out
);
    reg [3:0] memory [3:0]; // 4-bit memory with 4 addresses

    always @(posedge rw) begin
        if (rw) begin
            memory[addr] <= data_in; // Write data
        end else begin
            data_out <= memory[addr]; // Read data
        end
    end
endmodule