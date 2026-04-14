module top_module(
    input [3:0] D,
    input LD, CLK, CLR,
    output reg [3:0] Q
);reg [3:0] Q1, Q2, Q3;

always @(posedge CLK) begin
    if (CLR) begin
        Q1 <= 4'b0;
        Q2 <= 4'b0;
        Q3 <= 4'b0;
    end else if (LD) begin
        Q1 <= D;
        Q2 <= Q1;
        Q3 <= Q2;
    end else begin
        Q1 <= Q2;
        Q2 <= Q3;
        Q3 <= Q3 << 1;
    end
end

assign Q = Q3;

endmodule