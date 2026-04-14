module reg_file_32x64(
    input wire clk,
    input wire we,
    input wire [4:0] w_addr,
    input wire [63:0] w_data,
    input wire [4:0] r_addr1,
    input wire [4:0] r_addr2,
    output reg [63:0] r_data1,
    output reg [63:0] r_data2
    );

reg [63:0] reg_array [31:0];

always @(posedge clk) begin
    if (we) begin
        reg_array[w_addr] <= w_data;
    end
end

always @(*) begin
    r_data1 = reg_array[r_addr1];
    r_data2 = reg_array[r_addr2];
end

endmodule