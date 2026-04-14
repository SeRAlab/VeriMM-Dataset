module register_sync_load(CLK, RST, LD, D, Q);
input CLK, RST, LD;
input [15:0] D;
output [15:0] Q;
reg [15:0] Q;

always@(posedge CLK) begin
    if (RST)
        Q <= 16'b0000000000000000;
    else if (LD)
        Q <= D;
end

endmodule