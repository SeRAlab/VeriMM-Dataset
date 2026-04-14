module top_module(
  input clk,
  input reset,
  input in_valid,
  input [7:0] in_data,
  output out_valid,
  output [7:0] out_data
);parameter SYMBOLS_PER_BEAT = 1;
parameter BITS_PER_SYMBOL = 8;
parameter PIPELINE_READY = 1;
localparam DATA_WIDTH = SYMBOLS_PER_BEAT * BITS_PER_SYMBOL;

reg [DATA_WIDTH-1:0] data0;
reg [DATA_WIDTH-1:0] data1;
reg [1:0] full;

assign out_valid = (full == 2);
assign out_data = (full == 2) ? data1 : 8'h0;

always @(posedge clk, posedge reset) begin
  if (reset) begin
    data0 <= {DATA_WIDTH{1'b0}};
    data1 <= {DATA_WIDTH{1'b0}};
    full <= 2'b00;
  end else begin
    if (PIPELINE_READY) begin
      if (full == 2'b00) begin
        if (in_valid) begin
          data0 <= in_data;
          full <= 2'b01;
        end
      end else if (full == 2'b01) begin
        if (out_valid) begin
          data1 <= data0;
          full <= 2'b10;
        end else if (in_valid) begin
          data1 <= in_data;
          full <= 2'b11;
        end
      end else if (full == 2'b10) begin
        if (out_valid) begin
          full <= 2'b01;
        end
      end else if (full == 2'b11) begin
        if (out_valid) begin
          full <= 2'b10;
        end
      end
    end else begin
      if (full == 2'b00) begin
        if (in_valid && out_valid) begin
          out_data <= in_data;
        end
        if (in_valid) begin
          full <= 2'b01;
        end
      end else if (full == 2'b01) begin
        if (out_valid) begin
          full <= 2'b00;
        end else if (in_valid) begin
          full <= 2'b11;
          data1 <= in_data;
        end
      end else if (full == 2'b11) begin
        if (out_valid) begin
          full <= 2'b01;
        end
      end
    end
  end
end

endmodule