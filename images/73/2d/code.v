module top_module (
    input clk,
    input reset,
    input up,
    output [2:0] count );reg [2:0] count_reg;
    
    always @(posedge clk) begin
        if (reset)
            count_reg <= 3'b000;
        else if (up)
            count_reg <= count_reg + 1;
        else
            count_reg <= count_reg - 1;
    end
    
    assign count = count_reg;
    
endmodule