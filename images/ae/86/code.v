module top_module(input G, input CLR, input D, input CLK, output reg Q);always @(posedge CLK or negedge CLR)
    begin
        if (!CLR)
            Q <= 1'b0;
        else if (G)
            Q <= D;
    end
endmodule