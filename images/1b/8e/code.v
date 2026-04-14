module switching_regulator(
    input [7:0] Vin,
    input [7:0] Vref,
    input [7:0] Iload,
    output reg Vout
);

always @(*) begin
    if (Vin > Vref && Iload <= 10) 
        Vout = 1;
    else 
        Vout = 0;
end

endmodule