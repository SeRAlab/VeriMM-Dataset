module crc8_generator (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output reg [7:0] crc_out
);
    reg [7:0] crc;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 8'h00; // Initialize CRC to 0 on reset
        end else begin
            crc = crc ^ data_in; // XOR with input data
            for (i = 0; i < 8; i = i + 1) begin
                if (crc[7]) begin
                    crc = {crc[6:0], 1'b0} ^ 8'h07; // Shift and XOR with polynomial
                end else begin
                    crc = {crc[6:0], 1'b0}; // Just shift
                end
            end
            crc_out <= crc; // Update the output CRC
        end
    end
endmodule