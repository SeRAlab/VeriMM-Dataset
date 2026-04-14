module top_module (
    input clk,
    input areset,
    output [1:0] q );reg [1:0] q_reg;

    always @(posedge clk or posedge areset) begin
        if (areset)
            q_reg <= 2'b00;
        else
            q_reg <= {q_reg[1], q_reg[1] ^ q_reg[0]};
    end
    
    assign q = q_reg;
    
endmodule