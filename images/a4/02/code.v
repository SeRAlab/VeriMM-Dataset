module top_module(
    clk_1,
    rst,
    add_en,
    d1_12
    );input clk_1;
    input rst;
    input add_en;
    output reg [3:0] d1_12;
    reg [3:0] d1_12_tmp;
    
    always@( posedge clk_1 or posedge rst)
        if(rst)
            d1_12 <= 4'b0000;
        else
            d1_12 <= d1_12_tmp;
            
    always@( d1_12 or add_en )
        if( (d1_12 == 4'd1) && add_en )
            d1_12_tmp <= 4'd0;
        else if( add_en )
            d1_12_tmp <= d1_12 + 1'b1;
        else
            d1_12_tmp <= d1_12;
    
    
endmodule