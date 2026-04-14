module multiplier(
    input clk,
    input [12:0] A,
    input [12:0] B,
    output [26:0] Y,
    output [26:0] Z
);

reg [25:0] Y_reg;
reg [25:0] Z_reg;
reg [12:0] A_reg;
reg [12:0] B_reg;
reg [10:0] i;

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
    if(i == 0) begin
        Y_reg <= 0;
        Z_reg <= 0;
    end
    else begin
        if(B_reg[0] == 1) begin
            Y_reg <= Y_reg + (A_reg << (i-1));
            Z_reg <= Z_reg + ((~A_reg + 1) << (i-1));
        end
    end
    i <= i + 1;
end

assign Y = Y_reg;
assign Z = Z_reg;

endmodule