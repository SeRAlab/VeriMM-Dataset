module crc_generator (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire start,
    output reg [7:0] crc_out
);
    reg [7:0] crc;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 8'b0;
            crc_out <= 8'b0;
        end else if (start) begin
            crc <= data_in;
            for (i = 0; i < 8; i = i + 1) begin
                if (crc[7]) begin
                    crc <= {crc[6:0], 1'b0} ^ 8'b10011000; // CRC polynomial
                end else begin
                    crc <= {crc[6:0], 1'b0};
                end
            end
            crc_out <= crc;
        end
    end
endmodule