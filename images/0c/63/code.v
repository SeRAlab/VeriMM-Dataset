module TFlipFlop (
    input clk,
    input rst,
    input T,
    input enable,
    output reg Q
);
    always @(posedge clk or posedge rst) begin
        if (rst) 
            Q <= 0;
        else if (enable) 
            if (T)
                Q <= ~Q;
    end
endmodule