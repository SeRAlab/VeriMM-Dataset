module top_module(
  input clk,
  input reset_n,
  input enable,
  input pause,
  input load,
  input [7:0] ldata,
  output reg [7:0] data
);parameter seed = 8'h32;

  reg [7:0] lfsr_data;

  always @ (posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      lfsr_data <= seed;
    end
    else begin
      if (!enable) begin
        lfsr_data <= seed;
      end
      else begin
        if (load) begin
          lfsr_data <= ldata;
        end
        else begin
          if (!pause) begin
            lfsr_data[0] <= lfsr_data[7] ^ lfsr_data[0];
            lfsr_data[1] <= lfsr_data[0] ^ lfsr_data[1];
            lfsr_data[2] <= lfsr_data[1] ^ lfsr_data[2];
            lfsr_data[3] <= lfsr_data[2] ^ lfsr_data[3];
            lfsr_data[4] <= lfsr_data[3] ^ lfsr_data[4];
            lfsr_data[5] <= lfsr_data[4] ^ lfsr_data[5];
            lfsr_data[6] <= lfsr_data[5] ^ lfsr_data[6];
            lfsr_data[7] <= lfsr_data[6] ^ lfsr_data[7];
          end
        end
      end
    end
  end

  assign data = lfsr_data;

endmodule