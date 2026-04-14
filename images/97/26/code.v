module top_module(
    input [3:0] D,
    input LD, CLK, CLR,
    output reg [3:0] Q
);always @(posedge CLK or posedge CLR) begin
        if (CLR) begin
            Q <= 4'b0000;
        end else if (LD) begin
            Q <= D;
        end else begin
            Q <= {Q[2:0], Q[3]};
        end
    end

endmodule