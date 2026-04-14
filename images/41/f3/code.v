module top_module(
    input wire clk,
    input wire rst,

    
    input wire [31:0] r_data_i,
    output wire [31:0] r_data_o,
    output wire [31:0] r_addr_o,
    output wire r_we_o,

    
    input wire [31:0] c_data_i,
    output wire [31:0] c_data_o,
    output wire [31:0] c_addr_o,
    output wire c_we_o,

    
    input wire [31:0] mem_r_addr_i,
    input wire mem_r_read_en,
    output wire [31:0] mem_r_data_o,
    input wire [31:0] mem_c_addr_i,
    input wire mem_c_read_en,
    output wire [31:0] mem_c_data_o,

    
    input wire [31:0] wb_data_i,
    input wire [31:0] wb_addr_i,
    input wire wb_r_we_i,
    input wire wb_c_we_i,

    output wire r_rw_conflict_o);assign r_data_o = wb_data_i;
assign r_addr_o = wb_r_we_i ? wb_addr_i : mem_r_addr_i;
assign r_we_o = wb_r_we_i;

assign r_rw_conflict_o = wb_r_we_i == 1'b1 && mem_r_read_en == 1'b1;

reg [31:0] r_eff_addr_ff;
reg r_read_en_ff;
always @(posedge clk) begin
    if (rst) begin
        r_eff_addr_ff <= 0;
        r_read_en_ff <= 0;
    end else begin
        r_eff_addr_ff <= mem_r_addr_i;
        r_read_en_ff <= mem_r_read_en;
    end
end
assign mem_r_data_o = r_read_en_ff ? r_data_i : r_eff_addr_ff;

assign c_data_o = 32'b0; 
assign c_addr_o = mem_c_addr_i;
assign c_we_o = 1'b0;

reg [31:0] c_eff_addr_ff;
reg c_read_en_ff;
always @(posedge clk) begin
    if (rst) begin
        c_eff_addr_ff <= 0;
        c_read_en_ff <= 0;
    end else begin
        c_eff_addr_ff <= mem_c_addr_i;
        c_read_en_ff <= mem_c_read_en;
    end
end
assign mem_c_data_o = c_read_en_ff ? c_data_i : c_eff_addr_ff;

endmodule