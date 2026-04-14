module top_module(
    input CLK,
    input RST,
    input EN,
    input LOAD,
    input [3:0] D,
    output reg [3:0] Q
);always @(posedge CLK) begin
        if (RST) begin
            Q <= 4'b0000;
        end else if (EN) begin
            if (LOAD) begin
                Q <= D;
            end else begin
                Q <= Q + 1;
            end
        end
    end

endmodule