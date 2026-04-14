module SRAM_4bit (
    input [3:0] data_in,
    input write_enable,
    input read_enable,
    output reg [3:0] data_out
);
    reg [3:0] storage;

    always @(posedge write_enable) begin
        if (write_enable)
            storage <= data_in; // Write data to the storage
    end

    always @(posedge read_enable) begin
        if (read_enable)
            data_out <= storage; // Read data from the storage
    end
endmodule