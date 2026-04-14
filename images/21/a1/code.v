module crc_generator (
    input wire clk,
    input wire reset,
    input wire [15:0] data_in,
    output reg [15:0] crc_out
);
    reg [15:0] crc;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 16'hFFFF; // Initial value
        end else begin
            crc <= crc ^ data_in; // Start with input data
            for (i = 0; i < 16; i = i + 1) begin
                if (crc[15] == 1'b1) begin
                    crc <= (crc << 1) ^ 16'hA001; // Polynomial: x^16 + x^12 + x^5 + 1
                end else begin
                    crc <= crc << 1; // Just shift
                end
            end
            crc_out <= crc; // Update output
        end
    end
endmodule