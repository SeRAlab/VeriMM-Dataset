module switching_regulator (
    input wire Vin,
    input wire Vfb,
    output wire Vout
);
    assign Vout = (Vin > Vfb) ? 1'b1 : 1'b0;
endmodule