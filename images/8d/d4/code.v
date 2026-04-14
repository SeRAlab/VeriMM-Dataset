module top_module(
    input CLK,
    input RESET,
    input EN,
    input LOAD,
    input [3:0] D,
    output reg [3:0] Q,
    output reg [3:0] Q_N
);always @ (posedge CLK) begin
    if (RESET) begin
        Q <= 4'b0000;
    end else if (LOAD) begin
        Q <= D;
    end else if (EN) begin
        Q <= Q + 1;
    end
end

assign Q_N = ~Q;

endmodule