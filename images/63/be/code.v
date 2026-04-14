module top_module(
    input clock,
    input wr_en,                // Added write enable input
    input [3:0] rd_addr,
    input [15:0] wr_data,
    output reg [15:0] rd_data
);reg [15:0] mem [0:15];
    
    always @(posedge clock) begin
        if (wr_en) begin
            mem[rd_addr] <= wr_data;
        end
    end
    
    always @(posedge clock) begin
        rd_data <= mem[rd_addr];
    end

endmodule