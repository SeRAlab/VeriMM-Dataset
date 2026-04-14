module top_module(
    input clk,
    input rst,
    input en,
    output [3:0] Q
    );reg [3:0] Q1;
    
    always @ (posedge clk)
        if (rst) begin
            Q1 <= 4'b0000;
        end else if (en) begin
            Q1 <= Q1+1;
        end
    
    assign Q = Q1;
        
endmodule