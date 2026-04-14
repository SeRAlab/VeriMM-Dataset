module sram_cell (
    input wire [15:0] data_in,
    input wire [3:0] address,
    input wire rw, // read/write control: 1 for write, 0 for read
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16 cells of 16 bits each

    always @(posedge rw) begin
        if (rw) begin
            memory[address] <= data_in; // Write operation
        end 
        else begin
            data_out <= memory[address]; // Read operation
        end
    end
endmodule