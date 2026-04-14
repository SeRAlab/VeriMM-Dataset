module dual_port_ram_8x16 (
    input clk,
    input rst_n,
    input write_en,
    input [3:0] write_addr,
    input [7:0] write_data,
    input [3:0] read_addr1,
    input [3:0] read_addr2,
    output [7:0] read_data1,
    output [7:0] read_data2
);

reg [7:0] mem [15:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mem[0] <= 8'b0;
        mem[1] <= 8'b0;
        mem[2] <= 8'b0;
        mem[3] <= 8'b0;
        mem[4] <= 8'b0;
        mem[5] <= 8'b0;
        mem[6] <= 8'b0;
        mem[7] <= 8'b0;
        mem[8] <= 8'b0;
        mem[9] <= 8'b0;
        mem[10] <= 8'b0;
        mem[11] <= 8'b0;
        mem[12] <= 8'b0;
        mem[13] <= 8'b0;
        mem[14] <= 8'b0;
        mem[15] <= 8'b0;
    end else if (write_en) begin
        mem[write_addr] <= write_data;
    end
end

assign read_data1 = mem[read_addr1];
assign read_data2 = mem[read_addr2];

endmodule