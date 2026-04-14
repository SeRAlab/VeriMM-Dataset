module flash_memory (
    input [4:0] data_in,
    input write_enable,
    input read_enable,
    output reg [4:0] data_out
);
    reg [4:0] memory; // Internal memory cell

    always @(*) begin
        if (write_enable) begin
            memory = data_in; // Write data to memory
        end
        if (read_enable) begin
            data_out = memory; // Read data from memory
        end else begin
            data_out = data_out; // Maintain previous output if not reading
        end
    end
endmodule