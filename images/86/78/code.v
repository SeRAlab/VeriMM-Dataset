module top_module(
  input clk,
  input rst,
  input [3:0] data_in,
  input rf_in,
  output reg [3:0] data_out,
  output rf_out
);// Transmitter block
  reg [7:0] rf_counter;
  reg [3:0] rf_data;
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      rf_counter <= 0;
      rf_data <= 0;
    end else begin
      if (rf_counter == 0) begin
        rf_data <= data_in;
        rf_counter <= 7;
      end else begin
        rf_data <= rf_data >> 1;
        rf_counter <= rf_counter - 1;
      end
    end
  end
  assign rf_out = rf_data ? 1 : 0;

  // Receiver block
  reg [7:0] mf_counter;
  reg [7:0] mf_data;
  reg [2:0] demod_counter;
  reg [3:0] demod_data;
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      mf_counter <= 0;
      mf_data <= 0;
      demod_counter <= 0;
      demod_data <= 0;
      data_out <= 0;
    end else begin
      // Matched filter
      if (mf_counter < 8) begin
        mf_data <= {rf_in, mf_data[7:1]};
        mf_counter <= mf_counter + 1;
      end else begin
        // Demodulation
        if (demod_counter < 7) begin
          demod_data <= {rf_in, demod_data[3:1]};
          demod_counter <= demod_counter + 1;
        end else begin
          data_out <= demod_data;
          mf_counter <= 0;
          demod_counter <= 0;
        end
      end
    end
  end

endmodule