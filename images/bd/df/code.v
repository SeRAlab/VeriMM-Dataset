module top_module(
    input CLK,
    input RESET,
    output reg [3:0] Q
);always @(posedge CLK) begin
    if (RESET) begin
        Q <= 4'b0;
    end else begin
        if (Q == 4'b1111) begin
            Q <= 4'b0;
        end else begin
            Q <= Q + 1;
        end
    end
end

endmodule