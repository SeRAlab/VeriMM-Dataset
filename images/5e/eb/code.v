module top_module(
    i_input,
    o_LED
    );input i_input;
    output [1:0] o_LED;
        
    
        
    
    
    
    
    
    assign o_LED[0] = i_input;
    assign o_LED[1] = ~i_input;
    
endmodule