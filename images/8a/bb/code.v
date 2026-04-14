module top_module(nrst, clk, din, level_sel, level_mask, edge_sel, edge_mask, trig_out);input nrst;
    input clk;
    input [7:0] din;
    input [7:0] level_sel;
    input [7:0] level_mask;
    input [2:0] edge_sel;
    input edge_mask;
    output trig_out;
    
    reg d_last;
    wire d_sel;
    wire d_edge;
    wire m_edge;
    
    wire [7:0] d_level;
    wire [7:0] m_level;
    wire s_level;
    
    
    assign d_sel = din[edge_sel];
    
    
    always @(posedge clk or negedge nrst) begin
        if (~nrst) begin
            d_last <= 1'b0;
        end else begin
            d_last <= d_sel;
        end
    end
    
    
    assign d_edge = d_last ^ d_sel;
    
    assign m_edge = d_edge | edge_mask;
    
    assign d_level = ~(din ^ level_sel);
    
    assign m_level = d_level | level_mask;
    
    assign trig_out = &m_level & m_edge;
endmodule