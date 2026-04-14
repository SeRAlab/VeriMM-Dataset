module sram_cell (
    input [3:0] address,
    input [15:0] data_in,
    input write_enable,
    input read_enable,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16 memory locations, each 16 bits wide

    always @(*) begin
        if (write_enable) begin
            memory[address] <= data_in; // Write data to selected address
        end
    end

    always @(*) begin
        if (read_enable) begin
            data_out <= memory[address]; // Read data from selected address
        end else begin
            data_out <= 16'bz; // High impedance when not reading
        end
    end
endmodule