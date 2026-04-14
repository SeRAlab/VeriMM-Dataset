module top_module(X, Y, LG, EQ, RG);input [3:0] X, Y;
    output LG, EQ, RG;
    assign {LG, EQ, RG} = FUNC_COMP(X, Y);

    function [2:0]FUNC_COMP;
        input [3:0]X, Y;
        begin
            if(X > Y) begin
                FUNC_COMP = 3'b100;
            end else begin
                if(X < Y) begin
                    FUNC_COMP = 3'b001;
                end else begin
                    FUNC_COMP = 3'b010;
                end
            end
        end
    endfunction

endmodule