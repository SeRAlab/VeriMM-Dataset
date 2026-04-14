module top_module(
    input clk,                      // Added clk input
    input [3:0] multiplier,
    input [3:0] multiplicand,
    output reg [7:0] product
);reg [3:0] m_reg;
reg [7:0] p_reg;

always @(posedge clk) begin
    m_reg <= multiplier;
    p_reg <= 8'b0;                  // Changed to a specific zero initialization
end

always @(posedge clk) begin
    if (m_reg[0]) begin
        p_reg <= p_reg + (multiplicand << 0);
    end
    if (m_reg[1]) begin
        p_reg <= p_reg + (multiplicand << 1);
    end
    if (m_reg[2]) begin
        p_reg <= p_reg + (multiplicand << 2);
    end
    if (m_reg[3]) begin
        p_reg <= p_reg + (multiplicand << 3);
    end
end

assign product = p_reg;

endmodule