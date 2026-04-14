module eeprom_cell (
    input wire clk,
    input wire WE,
    input wire RE,
    input wire [7:0] D,
    output reg [7:0] Q
);
    reg [7:0] memory;

    always @(posedge clk) begin
        if (WE) begin
            memory <= D; // Write data to memory
        end
        if (RE) begin
            Q <= memory; // Read data from memory
        end
    end
endmodule