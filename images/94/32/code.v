module top_module(
    input wire aux_clk_i,
    input wire clk_fpga_i,
    input wire ram_loader_done_i,
    input wire clock_ready_i,
    output wire wb_clk_o,
    output wire dsp_clk_o,
    output wire ram_loader_rst_o,
    output wire processor_rst_o
);reg [1:0] wb_divider;
    reg [1:0] dsp_divider;
    
    assign wb_clk_o = aux_clk_i & wb_divider[1];
    assign dsp_clk_o = clk_fpga_i & dsp_divider[1];
    
    always @(posedge aux_clk_i) begin
        wb_divider <= wb_divider + 1;
    end
    
    always @(posedge clk_fpga_i) begin
        dsp_divider <= dsp_divider + 1;
    end
    
    assign ram_loader_rst_o = ram_loader_done_i;
    assign processor_rst_o = ~clock_ready_i;

endmodule