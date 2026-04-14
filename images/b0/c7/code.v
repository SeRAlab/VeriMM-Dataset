module top_module(
    input LOAD, RESET, DIR, CLK,
    input [3:0] D,
    output reg [3:0] Q
);reg [3:0] Q_reg1, Q_reg2, Q_reg3;

always @(posedge CLK) begin
    Q_reg1 <= Q;
    Q_reg2 <= Q_reg1;
    Q_reg3 <= Q_reg2;
    
    if (RESET) begin
        Q <= 4'b0;
    end else if (LOAD) begin
        Q <= D;
    end else if (DIR) begin
        Q <= Q_reg1 + 1;
    end else begin
        Q <= Q_reg1 - 1;
    end
end

endmodule