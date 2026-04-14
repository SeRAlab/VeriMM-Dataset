module crc_generator (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    output reg [7:0] crc_out
);
    reg [7:0] crc;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crc <= 8'b0;
        end else begin
            crc = data_in;
            for (i = 0; i < 8; i = i + 1) begin
                if (crc[7]) begin
                    crc = (crc << 1) ^ 8'hA7; // Polynomial: x^8 + x^2 + x + 1
                end else begin
                    crc = crc << 1;
                end
            end
            crc_out <= crc;
        end
    end
endmodule