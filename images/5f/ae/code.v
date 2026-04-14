module top_module(
    input [3:0] A,
    input [1:0] B,
    output [3:0] Q,
    output COUT
);reg [3:0] Q_reg;
reg COUT_reg;

always @(*) begin
    case(B)
        2'b00: begin
            Q_reg = A;
            COUT_reg = 1'b0;
        end
        2'b01: begin
            Q_reg = {A[2:0], COUT_reg};
            COUT_reg = A[3];
        end
        2'b10: begin
            Q_reg = {COUT_reg, A[3:1]};
            COUT_reg = A[0];
        end
        2'b11: begin
            Q_reg = {COUT_reg, A[3], A[2]};
            COUT_reg = A[1];
        end
    endcase
end

assign Q = Q_reg;
assign COUT = COUT_reg;

endmodule