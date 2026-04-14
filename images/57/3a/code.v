module register_file(CLK, RST, WR_EN, WR_ADDR, RD_ADDR1, RD_ADDR2, DATA_IN, DATA_OUT1, DATA_OUT2);
input CLK, RST, WR_EN;
input [1:0] WR_ADDR, RD_ADDR1, RD_ADDR2;
input [15:0] DATA_IN;
output [15:0] DATA_OUT1, DATA_OUT2;

reg [15:0] registers [0:3];

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        registers[0] <= 0;
        registers[1] <= 0;
        registers[2] <= 0;
        registers[3] <= 0;
    end
    else if (WR_EN) begin
        registers[WR_ADDR] <= DATA_IN;
    end
end

assign DATA_OUT1 = registers[RD_ADDR1];
assign DATA_OUT2 = registers[RD_ADDR2];

endmodule