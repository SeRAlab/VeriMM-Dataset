module top_module(
    input [15:0] D,
    input SH,
    input LD,
    output reg [15:0] Q
);always @ (posedge SH or posedge LD) begin
        if (LD) begin
            Q <= D;
        end else begin
            if (SH) begin
                Q <= {Q[14:0], 1'b0};
            end else begin
                Q <= {1'b0, Q[15:1]};
            end
        end
    end

endmodule