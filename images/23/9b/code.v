module power_gating(
    input [2:0] in,
    input control,
    output reg [2:0] out
);
    always @(*) begin
        if (control) begin
            out = in;
        end else begin
            out = 3'b000;
        end
    end
endmodule