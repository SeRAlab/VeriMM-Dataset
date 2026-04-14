module top_module(
    input CP,
    input M,
    input [3:0] D,
    input LD_n,
    input CLR_n,
    output reg [3:0] Q,
    output reg Qcc_n
);always @(posedge CP) begin
        if (CLR_n == 0) begin
            Q <= 0;
        end else if (LD_n == 0) begin
            Q <= D;
        end else if (M == 1) begin
            Q <= Q + 1;
        end
        Qcc_n <= ~Q[3];
    end
endmodule