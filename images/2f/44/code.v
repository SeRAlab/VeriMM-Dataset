module SRAM_Cell (
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    input wire we, // write enable
    input wire ce  // chip enable
);
    reg [7:0] memory;

    always @(posedge we or negedge ce) begin
        if (!ce) begin
            // Chip is disabled
            data_out <= 8'bz; // High impedance output
        end else if (we) begin
            // Write data
            memory <= data_in;
        end else begin
            // Read data
            data_out <= memory;
        end
    end
endmodule