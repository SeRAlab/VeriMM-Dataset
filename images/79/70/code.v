module top_module(
    input clk,
    input rst,
    input load,
    input [0:0] D,
    output [0:0] Q
);wire [0:0] Q_next;
    reg [0:0] Q_reg; // Change from wire to reg

    assign Q = Q_reg;

    assign Q_next[0] = (load == 1'b1) ? D : (Q_reg[0] + D[0]); // Modified to use D directly for addition

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q_reg <= 1'b0; // Reset condition
        end else begin
            Q_reg <= Q_next; // Update Q_reg with Q_next
        end
    end
    
endmodule