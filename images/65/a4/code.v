module top_module(
    input [3:0] address,
    input read,
    input clk,
    output reg [7:0] data_out
);parameter ROM_SIZE = 16;

reg [7:0] rom [0:ROM_SIZE-1];

initial begin
    rom[0] = 8'h01;
    rom[1] = 8'h02;
    rom[2] = 8'h03;
    rom[3] = 8'h04;
    rom[4] = 8'h05;
    rom[5] = 8'h06;
    rom[6] = 8'h07;
    rom[7] = 8'h08;
    rom[8] = 8'h09;
    rom[9] = 8'h0A;
    rom[10] = 8'h0B;
    rom[11] = 8'h0C;
    rom[12] = 8'h0D;
    rom[13] = 8'h0E;
    rom[14] = 8'h0F;
    rom[15] = 8'h10;
end

always @(posedge clk) begin
    if (read && address < ROM_SIZE) begin
        data_out <= rom[address];
    end
end

endmodule