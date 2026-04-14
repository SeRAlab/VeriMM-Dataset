module top_module(
    input RST,
    input UP_DOWN,
    input clk,              // Added clk input
    output reg [2:0] Q
);reg [2:0] Q_reg;

    always @(posedge clk) begin
        if (RST) begin
            Q_reg <= 3'b0;
            Q <= 3'b0;
        end
        else begin
            if (UP_DOWN) begin
                Q_reg <= Q_reg + 1;
            end
            else begin
                Q_reg <= Q_reg - 1;
            end
            Q <= Q_reg; // Update output Q based on the current value of Q_reg
        end
    end
    
endmodule