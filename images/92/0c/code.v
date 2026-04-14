module top_module(
    
    input clk_i,
    input rst_i,

    
    input [31:0] alu_i,
    input control_load_i,
    input control_store_i,
    input control_take_branch_i,
    input do_wb_i,
    input [4:0] wb_reg_i,
    output stall_o,

    
    output reg do_wb_o,
    output reg [4:0] wb_reg_o,
    output reg [31:0] wb_val_o
);reg [31:0] alu_r;
reg control_load;
reg control_store;

assign stall_o = 0;

always @(posedge clk_i)
begin
    if (rst_i) begin
        alu_r <= 0;
        control_load <= 0;
        control_store <= 0;
        do_wb_o <= 0;
        wb_reg_o <= 0;
    end else begin
        alu_r <= alu_i;
        control_load <= control_load_i;
        control_store <= control_store_i;
        do_wb_o <= do_wb_i;
        wb_reg_o <= wb_reg_i;
    end
end

always @*
begin
    if (control_load) begin
        wb_val_o = 99; 
    end else if (control_store) begin
        wb_val_o = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    end else begin
        wb_val_o = alu_r;
    end
end

endmodule