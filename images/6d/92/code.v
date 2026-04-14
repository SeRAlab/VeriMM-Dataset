module regfile_16bit_4regs(
    input               clk     ,
    input               rst     ,
    input               wr_en   ,
    input      [1:0]    rd_addr ,
    input      [1:0]    wr_addr ,
    input      [15:0]   wr_data ,

    output reg [15:0]   rd_data 
);

reg [15:0] registers [3:0];

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        registers[0] <= 16'b0;
        registers[1] <= 16'b0;
        registers[2] <= 16'b0;
        registers[3] <= 16'b0;
    end
    else if (wr_en)
        registers[wr_addr] <= wr_data;
end

always @(*)
begin
    rd_data = registers[rd_addr];
end

endmodule