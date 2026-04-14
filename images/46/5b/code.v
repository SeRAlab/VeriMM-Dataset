module top_module(
    input clk,
    input [9:0] addr,
    input [17:0] data_in,
    input write_en,
    output reg [17:0] data_out
);reg [17:0] ram[0:1023]; // Assuming a simple RAM implementation with 1024 entries

    always @(posedge clk) begin
        if (write_en) begin
            ram[addr] <= data_in; // Write data to RAM
        end
        data_out <= ram[addr]; // Read data from RAM
    end

endmodule