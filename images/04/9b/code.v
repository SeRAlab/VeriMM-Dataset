module crc_generator (
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    output reg [1:0] crc_out
);
    
    reg [1:0] crc;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 2'b00;
            crc_out <= 2'b00;
        end else begin
            crc = 2'b00; // Reset CRC for new input
            for (i = 0; i < 4; i = i + 1) begin
                crc[1] = (crc[1] ^ data_in[i]);
                if (i < 3) begin
                    crc[0] = (crc[0] ^ data_in[i]);
                end
            end
            crc_out <= crc;
        end
    end
endmodule