module switching_regulator (
    input [7:0] vin,
    input [7:0] vref,
    output reg [7:0] vout
);
    always @(*) begin
        if (vin > vref) begin
            vout = (vin > 8'd5) ? 8'd5 : vin; // Clamp vout to 5 volts max
        end else begin
            vout = vref;
        end
    end
endmodule