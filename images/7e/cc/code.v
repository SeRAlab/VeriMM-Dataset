module top_module(
  input Vin,
  input en,
  output reg Vout
);always @ (en, Vin) begin
    if (en) begin
      Vout <= 1.8; // Replace 1.8 with your desired constant voltage value
    end
    else begin
      Vout <= 0;
    end
  end

endmodule