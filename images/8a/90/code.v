module top_module(input D, input Clk, output reg Q);always @ (posedge Clk) begin
        if(Clk)
            begin
                Q <= D;
            end
    end
endmodule