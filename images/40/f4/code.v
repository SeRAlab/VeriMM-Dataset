module DAC (
    input [15:0] din,
    input valid,
    output reg [15:0] dout
);
    always @(*) begin
        if (valid) begin
            dout = din;
        end else begin
            dout = 16'b0;
        end
    end
endmodule