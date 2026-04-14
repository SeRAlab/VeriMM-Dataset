module top_module (
    input clk,
    input reset,
    input t,
    output q );reg q_reg;
    
    always @(posedge clk) begin
        if (reset)
            q_reg <= 1'b0;
        else if (t)
            q_reg <= ~q_reg;
    end
    
    assign q = q_reg;
    
endmodule