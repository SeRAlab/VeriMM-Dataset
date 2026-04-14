module top_module(
    input [10:0]addr,
    input[31:0] ms,
    input[7:0] btn,
    input en,
    output reg[31:0] out
);always @ (ms or btn or addr or en)
begin
    if(en)
    begin 
        if(addr == 11'd1)
            out = {btn,24'd0};
        else if(addr == 11'd2) 
            out = ms;
        else 
            out = 32'b0;
    end
    else
    begin
        out = 32'b0;
    end
end
endmodule