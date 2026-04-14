module reg_file_4x4(
    input clk,        // Clock signal.
    input rst,        // Reset signal.
    input wr_en,      // Write enable signal.
    input [1:0] rd_addr1, // First 2-bit read address input.
    input [1:0] rd_addr2, // Second 2-bit read address input.
    input [1:0] wr_addr,  // 2-bit write address input.
    input [3:0] wr_data,  // 4-bit write data input.

    output [3:0] rd_data1, // 4-bit read data output for rd_addr1.
    output [3:0] rd_data2  // 4-bit read data output for rd_addr2.
);

reg [3:0] reg_array [3:0]; // Array of 4 registers, each 4 bits wide.

//------------------------------------------------
// Register file operation
always @(posedge clk) begin
    if (rst) begin
        reg_array[0] <= 4'b0000; // Reset all registers to 0
        reg_array[1] <= 4'b0000;
        reg_array[2] <= 4'b0000;
        reg_array[3] <= 4'b0000;
    end
    else if (wr_en) begin
        reg_array[wr_addr] <= wr_data; // Write data to specified register
    end
end

//------------------------------------------------
// Read data outputs
assign rd_data1 = reg_array[rd_addr1]; // Read data for rd_addr1
assign rd_data2 = reg_array[rd_addr2]; // Read data for rd_addr2

endmodule