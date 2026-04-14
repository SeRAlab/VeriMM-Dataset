module top_module (
    input clk,
    input reset,
    input d,
    input enable,
    output q );reg q_reg;
    
    always @(posedge clk) begin
        if (reset)
            q_reg <= 1'b0;
        else if (enable)
            q_reg <= d;
    end
    
    assign q = q_reg;
    
endmodule