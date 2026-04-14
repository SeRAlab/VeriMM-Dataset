module top_module(
    input [7:0] Y,
    input [7:0] Cb,
    input [7:0] Cr,
    input [7:0] Ta,
    input [7:0] Tb,
    input [7:0] Tc,
    input [7:0] Td,
    output reg [7:0] binary
);always @(*) begin
    if (Y >= Ta && Y <= Tb && Cb >= Tc && Cb <= Td && Cr >= Tc && Cr <= Td) begin
        binary = 8'b1;
    end else begin
        binary = 8'b0;
    end
end

endmodule