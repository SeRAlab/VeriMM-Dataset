module reg_8bit_async_reset(CLK, RST, D, Q);
input CLK, RST;
input [7:0] D;
output [7:0] Q;
reg [7:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Q <= 8'b0;
    end else begin
        Q <= D;
    end
end

endmodule