module top_module(
  input clk,
  input [15:0] signal_in,
  input [3:0] control_in,
  output reg [3:0] waveform_out
);reg [255:0] shift_reg;
  reg [7:0] shift_count;
  
  always @(posedge clk) begin
    if (control_in == 4'b0000) begin
      shift_reg <= {shift_reg[251:0], signal_in[3:0]};
    end else if (control_in == 4'b0001) begin
      shift_reg <= {shift_reg[251:0], signal_in[7:4]};
    end else if (control_in == 4'b0010) begin
      shift_reg <= {shift_reg[251:0], signal_in[11:8]};
    end else if (control_in == 4'b0011) begin
      shift_reg <= {shift_reg[251:0], signal_in[15:12]};
    end else if (control_in == 4'b0100) begin
      shift_reg <= {shift_reg[251:0], signal_in[19:16]};
    end else if (control_in == 4'b0101) begin
      shift_reg <= {shift_reg[251:0], signal_in[23:20]};
    end else if (control_in == 4'b0110) begin
      shift_reg <= {shift_reg[251:0], signal_in[27:24]};
    end else if (control_in == 4'b0111) begin
      shift_reg <= {shift_reg[251:0], signal_in[31:28]};
    end else begin
      shift_reg <= shift_reg;
    end
    
    if (shift_count == 8) begin
      shift_count <= 0;
      waveform_out <= shift_reg[7:4];
      shift_reg <= {shift_reg[251:0], 4'b0};
    end else begin
      shift_count <= shift_count + 1;
      waveform_out <= shift_reg[7:4];
      shift_reg <= {shift_reg[251:0], shift_reg[3:0]};
    end
  end
  
endmodule