module top_module(
    input CLK,
    input RESET,
    input DIR,
    output reg [2:0] Q
);reg [2:0] Q_reg;
reg [2:0] Q_next;

always @(posedge CLK) begin
    if(RESET) begin
        Q_reg <= 3'b000;
    end else begin
        Q_reg <= Q_next;
    end
end

always @(*) begin
    if(DIR == 1'b0) begin
        Q_next = Q_reg + 3'b001;
    end else begin
        Q_next = Q_reg - 3'b001;
    end
end

assign Q = Q_reg;

endmodule