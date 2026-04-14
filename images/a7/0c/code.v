module top_module (
    input clk,
    input set,
    input rst,
    output reg [3:0] count);always @(posedge clk) begin
        if (rst)
            count <= 4'b0000;
        else if (set)
            count <= 4'b1111;
        else
            count <= count + 1;
    end
    
endmodule