module crc_generator (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output reg [11:0] crc_out
);
    reg [3:0] crc;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 4'b0000;
            crc_out <= 12'b0;
        end else begin
            crc = data_in[7:4] ^ crc; // Initial CRC value combines with the first 4 bits of data
            for (i = 3; i >= 0; i = i - 1) begin
                if (crc[3]) 
                    crc = {crc[2:0], 1'b0} ^ 4'b1011; // Polynomial x^4 + x + 1
                else 
                    crc = {crc[2:0], 1'b0};
            end
            // Final CRC is calculated
            crc_out <= {data_in, crc}; // Append CRC to the original data
        end
    end
endmodule