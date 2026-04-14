module flash_memory (
    input [3:0] data_in,
    input write_enable,
    input erase_enable,
    input read_enable,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(*) begin
        if (erase_enable) begin
            memory <= 4'b0000;  // Erase operation
        end else if (write_enable) begin
            memory <= data_in;  // Write operation
        end
    end

    always @(posedge read_enable) begin
        data_out <= memory;  // Read operation
    end
endmodule