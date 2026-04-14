module top_module(
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] D,
    output reg [63:0] P
);reg [31:0] B_inv;
reg [63:0] P_temp;
wire [31:0] D_temp;
integer i; // Declare i as an integer

assign D_temp = A + (~B_inv) + 1;

always @ (A or B) begin
    B_inv = ~B;
end

always @ (A or B) begin
    P_temp = 0;
    for (i = 0; i < 32; i = i + 1) begin
        if (B[i] == 1) begin
            P_temp = P_temp + (A << i);
        end
    end
    P = P_temp;
end

assign D = D_temp;

endmodule