module top_module(clk, rst, en, din, dout);input clk, rst, en;
input [7:0] din;
output [15:0] dout;

reg [15:0] crc;
reg [7:0] data;
reg [7:0] i;

always @(posedge clk) begin
    if (rst) begin
        crc <= 16'h0000;
        i <= 0;
    end
    else if (en) begin
        data <= din;
        for (i = 0; i < 8; i = i + 1) begin
            if ((crc & 16'h8000) == 16'h8000) begin
                crc <= (crc << 1) ^ 16'h1021;
            end
            else begin
                crc <= crc << 1;
            end
            if ((data & 1) == 1) begin
                crc <= crc ^ 16'h8005;
            end
            data <= data >> 1;
        end
    end
end

assign dout = crc;

endmodule