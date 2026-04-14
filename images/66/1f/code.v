module top_module (
    input clk,
    input areset,
    input load,
    input enable,
    input [7:0] data,
    output [7:0] q );reg [7:0] q_reg;
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            q_reg <= 8'b00000000;
        else if (load)
            q_reg <= data;
        else if (enable)
            q_reg <= q_reg;
    end
    
    assign q = q_reg;
    
endmodule