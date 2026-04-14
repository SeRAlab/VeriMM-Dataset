module top_module (
    input clk,
    input areset,
    output [3:0] q );reg [3:0] q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset)
            q_reg <= 4'b0000;
        else
            q_reg <= q_reg + 1;
    end
    
    assign q = q_reg;
    
endmodule