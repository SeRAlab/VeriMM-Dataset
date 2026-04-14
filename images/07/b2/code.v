module voltage_regulator (
    input [2:0] V_in,
    output reg [2:0] V_out
);
    always @(*) begin
        if (V_in < 3)
            V_out = 3;
        else if (V_in >= 3 && V_in < 6)
            V_out = V_in;
        else
            V_out = 6;
    end
endmodule