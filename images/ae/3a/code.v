module top_module (
    input clk,
    input reset,
    input [7:0] data,
    output [7:0] q );reg [7:0] q_reg;
    
    always @(posedge clk) begin
        if (reset)
            q_reg <= 8'b00000000;
        else
            q_reg <= data;
    end
    
    assign q = q_reg;
    
endmodule