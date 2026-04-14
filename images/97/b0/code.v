module top_module(
    
    input clk_i,
    input rst_i,

    
    input do_wb_i,
    input [4:0] wb_reg_i,
    input [31:0] wb_val_i,

    
    output reg do_wb_o,
    output reg [4:0] wb_reg_o,
    output reg [31:0] wb_val_o
);always @(posedge clk_i)
begin
    if (rst_i) begin
        do_wb_o <= 0;
        wb_reg_o <= 0;
        wb_val_o <= 0;
    end else begin
        do_wb_o <= do_wb_i;
        wb_reg_o <= wb_reg_i;
        wb_val_o <= wb_val_i;
    end
end

endmodule