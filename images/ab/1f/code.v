module top_module(
  input Vin,
  input Vref,
  input hyst,
  output reg Vout
);always @(Vin, Vref, hyst, Vout) begin
    if (Vin > Vref + hyst) begin
      Vout <= 1'b1;
    end else if (Vin < Vref - hyst) begin
      Vout <= 1'b0;
    end else if (Vin > Vref - hyst && Vin < Vref + hyst) begin
      Vout <= Vout;
    end
  end
  
  always @(Vout) begin
    if (Vout == 1'b1) begin
      Vout <= Vout & (Vin < Vref - hyst);
    end else if (Vout == 1'b0) begin
      Vout <= Vout | (Vin > Vref + hyst);
    end
  end
  
endmodule