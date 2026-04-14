module top_module(
    input CLK,
    input CTRL,
    input LOAD,
    input [3:0] D,
    output reg [3:0] Q
);always @(posedge CLK) begin
    if (CTRL) begin
        Q <= 4'b0;
    end else if (LOAD) begin
        Q <= D;
    end else begin
        Q <= Q + 1;
    end
end

endmodule