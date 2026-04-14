module top_module(
    input [3:0] x,y,
    output reg [4:0] z
    );function [4:0] add_two_values;
        input [3:0] x,y;
        begin
            add_two_values = x+y;
        end
    endfunction
    always
        @(x or y)
        begin
            z = add_two_values(x,y);
        end 
    
endmodule