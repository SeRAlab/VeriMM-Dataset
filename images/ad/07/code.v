module top_module(clka, wea, addra, dina, douta);input clka;
  input wea;
  input [9:0] addra;
  input [7:0] dina;
  output [7:0] douta;

  reg [7:0] douta_reg;
  reg jump;

  always @(posedge clka) begin
    if (wea && (addra == 10'h05)) begin
      douta_reg <= dina;
      jump <= 1;
    end else if (jump) begin
      douta_reg <= dina;
      jump <= 0;
    end else begin
      douta_reg <= 0;
    end
  end

  assign douta = douta_reg;

endmodule