module decoder (
    input enable,
    input [1:0] in,
    output reg [3:0] out
);

    always @(*) begin
        if (enable) begin
            out = 4'b0000;
            out[in] = 1'b1;
        end else begin
            out = 4'b0000;
        end
    end

endmodule