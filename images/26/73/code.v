module crc_generator (
    input wire clk,
    input wire reset,
    input wire [31:0] data_in,
    input wire [31:0] polynomial,
    output reg [31:0] crc_out
);
    reg [31:0] crc;
    integer i, j;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 32'b0;
        end else begin
            crc <= crc ^ data_in; // Initial XOR with input data
            for (i = 31; i >= 0; i = i - 1) begin
                if (crc[31] == 1'b1) begin
                    crc = crc << 1;
                    crc = crc ^ polynomial; // XOR with polynomial
                end else begin
                    crc = crc << 1; // Just shift
                end
            end
        end
    end

    always @(posedge clk) begin
        crc_out <= crc;
    end
endmodule