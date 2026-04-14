module top_module(
  input pclk,
  input [7:0] data,
  output reg [15:0] rgb
);reg [3:0] red;
  reg [3:0] green;
  reg [3:0] blue;

  always @ (posedge pclk) begin
    if (data == 8'hFF) begin
      red <= 4'hF;
      green <= 4'hF;
      blue <= 4'hF;
    end else if (data == 8'hF0) begin
      red <= 4'hF;
      green <= 4'h0;
      blue <= 4'h0;
    end else if (data == 8'h0F) begin
      red <= 4'h0;
      green <= 4'hF;
      blue <= 4'h0;
    end else if (data == 8'h00) begin
      red <= 4'h0;
      green <= 4'h0;
      blue <= 4'hF;
    end else begin
      red <= 4'h0;
      green <= 4'h0;
      blue <= 4'h0;
    end
  end

  assign rgb = {red, green, blue};

endmodule