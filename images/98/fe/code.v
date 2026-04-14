module top_module(
  input [31:0] data_in,
  input [4:0] shift_amount,
  input clk,
  input reset,
  output reg [31:0] data_out,
  output reg zero_flag
);reg [31:0] reg_file [0:4];
  reg [4:0] stage;
  reg [31:0] shifted_data;
  reg zero;

  always @(*) begin
    case (stage)
      0: begin
        reg_file[0] = data_in;
        shifted_data = data_in;
      end
      1: begin
        reg_file[1] = shifted_data;
        shifted_data = reg_file[0] << shift_amount;
      end
      2: begin
        reg_file[2] = shifted_data;
        shifted_data = reg_file[1] << shift_amount;
      end
      3: begin
        reg_file[3] = shifted_data;
        shifted_data = reg_file[2] << shift_amount;
      end
      4: begin
        reg_file[4] = shifted_data;
        shifted_data = reg_file[3] << shift_amount;
      end
      5: begin
        data_out = shifted_data;
        zero = (shifted_data == 0);
      end
      default: begin
        shifted_data = shifted_data; // hold previous value
      end
    endcase
  end

  always @(posedge clk) begin
    if (reset) begin
      stage <= 0;
      zero_flag <= 0;
      data_out <= 0;
    end else begin
      if (stage == 5) begin
        stage <= 0;
        zero_flag <= zero;
      end else begin
        stage <= stage + 1;
      end
    end
  end

endmodule