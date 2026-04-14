module voltage_regulator (
    input [2:0] vin,
    output reg [2:0] vout
);

always @(*) begin
    if (vin > 3'd5)
        vout = 3'd5;
    else
        vout = vin;
end

endmodule