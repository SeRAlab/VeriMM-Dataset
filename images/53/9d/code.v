module top_module(
       input [7:0] pll_value,
       output [5:0] high,
       output [5:0] low,
       output w_edge
    );wire [5:0]  temp;
    wire        temp_edge;
    
    assign temp_edge = pll_value[0];
    assign temp = pll_value[6:1];
    
    assign low = pll_value[6:1] + pll_value[0];
    assign high = (temp == 6'b0) ? 6'h01 : temp;
    assign w_edge = (temp == 6'b0) ? 1'b0 : temp_edge;
    
endmodule