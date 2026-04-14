module top_module(
    input clk,
    input [15:0] A,
    input [3:0] B,
    input S,
    output reg [15:0] P
);always @(posedge clk) begin
    if (S == 0) begin // logical shift
        if (B[3] == 1) begin
            P = 16'b0;
        end else begin
            P = A << B;
        end
    end else begin // arithmetic shift
        if (B[3] == 1) begin
            P = {16{A[15]}};
        end else begin
            P = A >> B;
        end
    end
end

endmodule