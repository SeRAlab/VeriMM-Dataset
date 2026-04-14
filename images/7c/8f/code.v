module top_module (
    input clk,
    input sreset,
    input [5:0] reset_value,
    output [5:0] q );reg [5:0] q_reg;

    always @(posedge clk) begin
        if (sreset)
            q_reg <= reset_value;
        else
            q_reg <= q_reg + 1;
    end
    
    assign q = q_reg;
    
endmodule