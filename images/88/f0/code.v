module top_module(clk, rd_enable, wr_enable, wr_addr, wr_data, rd_addr, rd_data);parameter BLOCK_DATA_SIZE = 8;
    parameter BLOCK_AMOUNT = 16;
    parameter BLOCK_BIT_WIDTH = 4;
    
    input rd_enable, wr_enable, clk;
    input [BLOCK_BIT_WIDTH-1:0] wr_addr, rd_addr;
    input [BLOCK_DATA_SIZE-1:0] wr_data;
    output reg [BLOCK_DATA_SIZE-1:0] rd_data;
    
    reg [BLOCK_DATA_SIZE-1:0] BLOCK_RAM [BLOCK_AMOUNT-1:0];
    
    always @ (posedge clk)
    begin
        if(wr_enable) begin
        
            BLOCK_RAM[wr_addr] <= wr_data;
        end
        if (rd_enable) begin
        
            rd_data <= BLOCK_RAM[rd_addr];
        end
    end
endmodule