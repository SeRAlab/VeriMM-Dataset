module top_module(
    input [3:0] D,
    input clk,       // Added clk input to fix the error
    output reg [1:0] Y
);reg [1:0] Y_reg;
    
    always @(*) begin
        Y_reg[1] = D[3];
        if (D[3] == 1) begin
            Y_reg[0] = 0;
        end else if (D[2] == 1) begin
            Y_reg[0] = 1;
        end else if (D[1] == 1) begin
            Y_reg[0] = 0;
        end else if (D[0] == 1) begin
            Y_reg[0] = 1;
        end else begin
            Y_reg[0] = 0;
        end
    end
    
    always @(posedge clk) begin
        Y <= Y_reg;
    end
endmodule