module crc_generator (
    input [7:0] data_in,
    output reg [7:0] crc_out
);
    
    wire [15:0] temp;
    assign temp = {data_in, 8'b00000000}; // Append 8 zeros to the data input

    // CRC polynomial: x^8 + x^2 + x + 1 (binary: 100000111)
    wire [7:0] poly = 8'b100000111;

    integer i;
    
    always @(*) begin
        crc_out = temp[15:8]; // Initialize CRC with the first 8 bits (data)
        
        for (i = 0; i < 8; i = i + 1) begin
            if (crc_out[7] == 1'b1) begin
                crc_out = (crc_out << 1) ^ poly; // Shift left and XOR with polynomial
            end else begin
                crc_out = crc_out << 1; // Just shift left
            end
        end
    end
endmodule