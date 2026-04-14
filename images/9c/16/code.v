module top_module(
    input [3:0] D,
    input LD,
    input SH,
    output reg [3:0] Q
);always @ (posedge SH or posedge LD) begin
        if (LD) begin
            Q <= D;
        end
        else begin
            Q <= {Q[2:0], 1'b0};
        end
    end

endmodule