module top_module(
  input RST,
  input CLK,
  input ENA,
  input [7:0] RGA,
  input [7:0] RGB,
  output [7:0] RGZ,
  input [1:0] KEY
);reg [7:0] RGB_reg;
  reg [7:0] RGZ_reg;

  always @(posedge CLK) begin
    if (ENA) begin
      RGB_reg <= RGA;
    end
  end

  always @(negedge CLK) begin
    if (ENA) begin
      RGZ_reg <= RGB;
    end
  end

  assign RGZ = (KEY == 2'b00) ? (RGA & RGB_reg) :
               (KEY == 2'b01) ? (RGA | RGB_reg) :
               (KEY == 2'b10) ? (RGA ^ RGB_reg) :
               (~RGA);

  always @(posedge CLK, negedge RST) begin
    if (RST == 0) begin
      RGB_reg <= 8'b0;
      RGZ_reg <= 8'b0;
    end
  end

endmodule