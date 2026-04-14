module LDO_Regulator (
    input wire clk,
    input wire enable,
    input wire [7:0] Vin,
    output reg [7:0] Vout
);
    always @(posedge clk) begin
        if (enable) begin
            // Simple regulation logic: output is Vin limited to a max value of 5V (8'd255)
            if (Vin > 8'd255)
                Vout <= 8'd255;
            else
                Vout <= Vin;
        end
    end
endmodule