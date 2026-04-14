module top_module (
    input clk,
    input reset,
    input s,
    input r,
    output q );reg q_reg;
    
    always @(posedge clk) begin
        if (reset)
            q_reg <= 1'b0;
        else if (s && ~r)
            q_reg <= 1'b1;
        else if (~s && r)
            q_reg <= 1'b0;
    end
    
    assign q = q_reg;
    
endmodule