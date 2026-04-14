module top_module(
    input CLK,
    input RST,
    input DIR,
    output reg [3:0] Q
);reg [3:0] Q_reg1, Q_reg2, Q_reg3;

always @(posedge CLK) begin
    if (RST) begin
        Q_reg1 <= 4'b0000;
        Q_reg2 <= 4'b0000;
        Q_reg3 <= 4'b0000;
    end else begin
        Q_reg1 <= Q;
        Q_reg2 <= Q_reg1;
        Q_reg3 <= Q_reg2;
    end
end

always @(posedge CLK) begin
    if (RST) begin
        Q <= 4'b0000;
    end else begin
        if (DIR) begin
            Q <= Q_reg3 - 1;
        end else begin
            Q <= Q_reg3 + 1;
        end
    end
end

endmodule