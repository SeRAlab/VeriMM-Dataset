module top_module(
  input [n-1:0] data,
  input RS,
  input RW,
  input E,
  input CLK,
  output [m-1:0] pixel
);parameter n = 8; // number of data signals
parameter m = 16; // number of pixel signals

reg [n-1:0] data_reg;
reg RS_reg;
reg RW_reg;
reg E_reg;

always @(posedge CLK) begin
  data_reg <= data;
  RS_reg <= RS;
  RW_reg <= RW;
  E_reg <= E;
end

reg [m-1:0] pixel_reg;

always @(posedge CLK) begin
  if (E_reg == 1'b1) begin
    if (RS_reg == 1'b1) begin
      // write data
      pixel_reg <= {16{1'b0}};
      pixel_reg[15] <= data_reg[0];
      pixel_reg[14] <= data_reg[1];
      pixel_reg[13] <= data_reg[2];
      pixel_reg[12] <= data_reg[3];
      pixel_reg[11] <= data_reg[4];
      pixel_reg[10] <= data_reg[5];
      pixel_reg[9] <= data_reg[6];
      pixel_reg[8] <= data_reg[7];
    end else begin
      // write command
      case (data_reg)
        8'h01: pixel_reg <= {16{1'b0}}; // clear display
        8'h02: pixel_reg <= {16{1'b0}}; // return home
        8'h0C: pixel_reg <= {16{1'b0}}; // display on, cursor off
        8'h0F: pixel_reg <= {16{1'b0}}; // display on, cursor blinking
        default: pixel_reg <= {16{1'b0}};
      endcase
    end
  end
end

assign pixel = pixel_reg;

endmodule