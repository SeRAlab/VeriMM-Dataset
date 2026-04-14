module top_module(
    input CLK,
    input RESET,
    input DIR,
    input LOAD,
    input [3:0] data_in,
    input [3:0] MAX_COUNT,
    output reg [3:0] Q
);reg [3:0] Q_reg;
reg [3:0] Q_next;

always @(posedge CLK) begin
    if (RESET) begin
        Q_reg <= 4'b0;
    end else if (LOAD) begin
        Q_reg <= data_in;
    end else if (DIR) begin
        if (Q_reg == MAX_COUNT) begin
            Q_next <= Q_reg;
        end else begin
            Q_next <= Q_reg - 1;
        end
    end else begin
        if (Q_reg == MAX_COUNT) begin
            Q_next <= Q_reg;
        end else begin
            Q_next <= Q_reg + 1;
        end
    end
end

assign Q = Q_reg;

always @(posedge CLK) begin
    Q_reg <= Q_next;
end

endmodule