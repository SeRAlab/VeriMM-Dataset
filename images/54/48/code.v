module reg_file_16x8(
    input           clk,
    input           rst_n,
    input           we,
    input   [2:0]   write_addr,
    input   [2:0]   read_addr,
    input   [15:0]  write_data,
    output  reg [15:0] read_data
);

reg [15:0] reg_array [7:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg_array[0] <= 16'b0;
        reg_array[1] <= 16'b0;
        reg_array[2] <= 16'b0;
        reg_array[3] <= 16'b0;
        reg_array[4] <= 16'b0;
        reg_array[5] <= 16'b0;
        reg_array[6] <= 16'b0;
        reg_array[7] <= 16'b0;
    end else if (we) begin
        reg_array[write_addr] <= write_data;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data <= 16'b0;
    end else begin
        read_data <= reg_array[read_addr];
    end
end

endmodule