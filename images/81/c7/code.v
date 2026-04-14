module dff_enable (D, CLK, EN, Q);
input D, CLK, EN;
output reg Q;

always @(posedge CLK) begin
    if (EN)
        Q <= D;
end

endmodule