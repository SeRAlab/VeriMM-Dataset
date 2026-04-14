module top_module(
    
    input wire clk_in,
    input wire rst_in,
    input wire rdy_in,
    
    input wire mem_we,
    input wire[31:0] mem_w_addr,
    input wire[31:0] mem_w_data,
    input wire busy_in,
    
    output reg wb_we,
    output reg[31:0] wb_w_addr,
    output reg[31:0] wb_w_data,
    
    input wire mem_stall
);always @ (posedge clk_in or posedge rst_in) begin
        if (rst_in) begin
            wb_we <= 0;
            wb_w_addr <= 0;
            wb_w_data <= 0;
        end
        else if (busy_in) begin
            wb_we <= 0;
            wb_w_addr <= 0;
            wb_w_data <= 0;
        end
        else if (!mem_stall && rdy_in) begin
            wb_we <= mem_we;
            wb_w_addr <= mem_w_addr;
            wb_w_data <= mem_w_data;
        end
    end
    
endmodule