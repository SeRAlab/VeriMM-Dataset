module top_module (
    input clk,
    input areset,
    input [7:0] init,
    output [7:0] q );reg [7:0] q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset)
            q_reg <= init;
        else
            q_reg <= {q_reg[6:0], q_reg[7] ^ q_reg[5]};
    end
    
    assign q = q_reg;
    
endmodule