module LDO_Regulator (
    input wire control,
    input wire vin,
    output wire vout
);
    assign vout = (control) ? 3'b011 : 3'b000; // 3.3V is represented as 3'b011
endmodule