module top_module(
    input  i0,
    input  i1,
    input  select,
    output reg d
    );always @(i0,i1,select)
    begin
        d = 0;
        
        if(select == 1'b0) begin
            d = i0;
        end
        else if(select == 1'b1) begin
            d = i1;
        end
    end    
    
endmodule