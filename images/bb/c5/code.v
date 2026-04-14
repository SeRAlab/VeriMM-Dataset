module top_module(CK, RST, Q);input  CK;
input  RST;
output reg [1:0] Q;

always @(posedge CK) begin
    if (RST) begin
        Q <= 2'b0;
    end else begin
        Q <= Q + 2'b1;
    end
end

endmodule