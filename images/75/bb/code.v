module top_module(
    input [3:0] D,
    input Clk,
    input reset,
    input load,
    output reg [3:0] Q
    );always @(posedge Clk) begin
        if (reset) begin
            Q <= 4'b0000;
        end else if (load) begin
            Q <= D;
        end
    end
    
endmodule