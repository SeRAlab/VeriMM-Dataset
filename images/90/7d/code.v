module top_module(
    input rst,
    input wr_clk,
    input rd_clk,
    input [63:0] din,
    input wr_en,
    input rd_en,
    output reg [63:0] dout,
    output reg full,
    output reg empty,
    output reg [8:0] rd_data_count,
    output reg [8:0] wr_data_count
);reg [9:0] wr_addr;
    reg [9:0] rd_addr;
    reg [9:0] wr_next_addr;
    reg [9:0] rd_next_addr;
    
    reg [8:0] data_count;
    
    reg [63:0] ram [511:0];
    
    assign full = (data_count == 512);
    assign empty = (data_count == 0);
    
    always @(posedge wr_clk) begin
        if (rst) begin
            wr_addr <= 0;
            wr_next_addr <= 0;
        end else if (wr_en && !full) begin
            ram[wr_addr] <= din;
            wr_addr <= wr_next_addr;
            wr_next_addr <= wr_next_addr + 1;
            wr_data_count <= wr_data_count + 1;
            data_count <= data_count + 1;
        end
    end
    
    always @(posedge rd_clk) begin
        if (rst) begin
            rd_addr <= 0;
            rd_next_addr <= 0;
        end else if (rd_en && !empty) begin
            dout <= ram[rd_addr];
            rd_addr <= rd_next_addr;
            rd_next_addr <= rd_next_addr + 1;
            rd_data_count <= rd_data_count + 1;
            data_count <= data_count - 1;
        end
    end
    
endmodule