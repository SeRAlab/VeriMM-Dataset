module top_module (
    input clk,
    input areset,
    input enable,
    output [3:0] count );reg [3:0] count_reg;
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            count_reg <= 4'b0000;
        else if (enable)
            count_reg <= count_reg + 1;
    end
    
    assign count = count_reg;
    
endmodule