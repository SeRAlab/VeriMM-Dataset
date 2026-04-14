module top_module(
    B,
    G
);input [7:0] B;
output [7:0] G;
reg [7:0] G;






always @(B) begin: BIN2GRAY_LOGIC
    integer i;
    reg [9-1:0] Bext;
    Bext = 9'h0;
    Bext = B;
    for (i=0; i<8; i=i+1) begin
        G[i] = (Bext[(i + 1)] ^ Bext[i]);
    end
end

endmodule