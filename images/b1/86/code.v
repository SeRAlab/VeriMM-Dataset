module top_module (
    input clk,
    input areset,
    input up,
    output [7:0] q );reg [7:0] q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset)
            q_reg <= 8'b00000000;
        else if (up)
            q_reg <= q_reg + 1;
        else
            q_reg <= q_reg - 1;
    end
    
    assign q = q_reg;
    
endmodule