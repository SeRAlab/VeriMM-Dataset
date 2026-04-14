module regfile32bit (
    input wire clk,
    input wire rst,
    input wire we,
    input wire [1:0] rd_addr1,
    input wire [1:0] rd_addr2,
    input wire [1:0] wr_addr,
    input wire [31:0] wr_data,
    output reg [31:0] rd_data1,
    output reg [31:0] rd_data2
);

    reg [31:0] registers [3:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            registers[0] <= 32'b0;
            registers[1] <= 32'b0;
            registers[2] <= 32'b0;
            registers[3] <= 32'b0;
        end else if (we) begin
            registers[wr_addr] <= wr_data;
        end
    end

    always @(*) begin
        rd_data1 = registers[rd_addr1];
        rd_data2 = registers[rd_addr2];
    end

endmodule