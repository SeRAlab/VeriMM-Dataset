module crc_generator (
    input wire [31:0] data,
    input wire [31:0] polynomial,
    output reg [31:0] crc
);
    integer i;
    reg [31:0] data_reg;

    always @(*) begin
        data_reg = data; // Copy the input data
        crc = 32'b0; // Initialize CRC to zero

        for (i = 0; i < 32; i = i + 1) begin
            if (data_reg[31] == 1'b1) begin
                data_reg = data_reg ^ polynomial; // XOR with polynomial
            end
            data_reg = data_reg << 1; // Shift left
        end
        crc = data_reg; // Output the computed CRC
    end
endmodule