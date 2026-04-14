module voltage_regulator (
    input [4:0] Vin,
    output reg [4:0] Vout
);
    always @(*) begin
        if (Vin < 5'd16) 
            Vout = Vin;
        else if (Vin < 5'd32) 
            Vout = 5'd16;
        else if (Vin < 5'd48) 
            Vout = 5'd32;
        else 
            Vout = 5'd48;
    end
endmodule