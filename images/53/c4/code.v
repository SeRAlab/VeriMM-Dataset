module top_module (
    input clk,
    input areset,
    output [4:0] q );reg [4:0] q_reg;
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            q_reg <= 5'b00001; // Non-zero initial value
        else
            q_reg <= {q_reg[3:0], q_reg[4] ^ q_reg[2]};
    end
    
    assign q = q_reg;
    
endmodule