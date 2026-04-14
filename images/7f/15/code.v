module top_module(
    src_clk            ,
    clk_en             ,
    gated_clk           
);input               src_clk     ;
    input               clk_en      ;
    output              gated_clk   ;
    
    
    
    
    
    
    
    
    reg                 clk_en_reg      ;

    
    
    
    
    
    
    always @(posedge src_clk) begin : CLK_EN_REG
        clk_en_reg  <= clk_en;
    end
    assign  gated_clk   = clk_en_reg & src_clk ;
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    

    
endmodule