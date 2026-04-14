module top_module(x1, x2);input[31:0]x1;

    
    output reg[31:0]x2;

    
    always@(x1)
    begin
        
        x2 = !x1;
    end
endmodule