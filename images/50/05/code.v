module reg_file_32bit
(
    input clk,
    input rst_n,
    input we,
    input [2:0] w_addr,
    input [31:0] w_data,
    input [2:0] r_addr_a,
    input [2:0] r_addr_b,
    output reg [31:0] r_data_a,
    output reg [31:0] r_data_b
);

reg [31:0] registers [0:7];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        registers[0] <= 32'b0;
        registers[1] <= 32'b0;
        registers[2] <= 32'b0;
        registers[3] <= 32'b0;
        registers[4] <= 32'b0;
        registers[5] <= 32'b0;
        registers[6] <= 32'b0;
        registers[7] <= 32'b0;
    end
    else if (we) begin
        registers[w_addr] <= w_data;
    end
end

always @(*) begin
    r_data_a = registers[r_addr_a];
    r_data_b = registers[r_addr_b];
end

endmodule