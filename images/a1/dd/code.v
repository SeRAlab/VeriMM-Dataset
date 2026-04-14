module top_module(
    clk,
    shiftnld,
    ldsrc,
    crcerror,
    regout
);input clk;
input shiftnld;
input ldsrc;

output crcerror;
output regout;

reg [31:0] crc;
reg [31:0] regout_reg;
reg [31:0] data_reg;

parameter polynomial = 32'h04C11DB7;

assign crcerror = (crc == 32'h04C11DB7) ? 1'b0 : 1'b1;
assign regout = regout_reg;

always @(posedge clk) begin
    // Shift in new data
    data_reg <= {data_reg[23:0], ldsrc};

    // Shift in new shiftnld value
    crc <= {crc[31:1], shiftnld};

    // Calculate new CRC
    if (shiftnld) begin
        crc <= crc ^ polynomial;
    end

    // Update regout_reg
    regout_reg <= crc;
end

endmodule