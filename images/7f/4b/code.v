module top_module(
  input clk,
  input reset,
  input [31:0] data,
  input [4:0] amount,
  input dir,
  input load,
  output reg [31:0] q
);reg [31:0] shift_reg;

  always @(posedge clk) begin
    if (reset) begin
      shift_reg <= 0;
    end else begin
      if (load) begin
        shift_reg <= data;
      end else if (dir == 0) begin
        shift_reg <= {shift_reg[30:0], 1'b0}; // Shift left
      end else begin
        shift_reg <= {1'b0, shift_reg[31:1]}; // Shift right
      end
    end
  end

  always @* begin
    case (amount)
      5'd0: q = shift_reg;
      5'd1: q = (dir == 0) ? {shift_reg[30:0], 1'b0} : {1'b0, shift_reg[31:1]};
      5'd2: q = (dir == 0) ? {shift_reg[28:0], 2'b00} : {2'b00, shift_reg[31:2]};
      5'd3: q = (dir == 0) ? {shift_reg[27:0], 3'b000} : {3'b000, shift_reg[31:3]};
      5'd4: q = (dir == 0) ? {shift_reg[26:0], 4'b0000} : {4'b0000, shift_reg[31:4]};
      5'd5: q = (dir == 0) ? {shift_reg[25:0], 5'b00000} : {5'b00000, shift_reg[31:5]};
      5'd6: q = (dir == 0) ? {shift_reg[24:0], 6'b000000} : {6'b000000, shift_reg[31:6]};
      5'd7: q = (dir == 0) ? {shift_reg[23:0], 7'b0000000} : {7'b0000000, shift_reg[31:7]};
      5'd8: q = (dir == 0) ? {shift_reg[22:0], 8'b00000000} : {8'b00000000, shift_reg[31:8]};
      5'd9: q = (dir == 0) ? {shift_reg[21:0], 9'b000000000} : {9'b000000000, shift_reg[31:9]};
      5'd10: q = (dir == 0) ? {shift_reg[20:0], 10'b0000000000} : {10'b0000000000, shift_reg[31:10]};
      5'd11: q = (dir == 0) ? {shift_reg[19:0], 11'b00000000000} : {11'b00000000000, shift_reg[31:11]};
      5'd12: q = (dir == 0) ? {shift_reg[18:0], 12'b000000000000} : {12'b000000000000, shift_reg[31:12]};
      5'd13: q = (dir == 0) ? {shift_reg[17:0], 13'b0000000000000} : {13'b0000000000000, shift_reg[31:13]};
      5'd14: q = (dir == 0) ? {shift_reg[16:0], 14'b00000000000000} : {14'b00000000000000, shift_reg[31:14]};
      5'd15: q = (dir == 0) ? {shift_reg[15:0], 15'b000000000000000} : {15'b000000000000000, shift_reg[31:15]};
      5'd16: q = (dir == 0) ? {shift_reg[14:0], 16'b0000000000000000} : {16'b0000000000000000, shift_reg[31:16]};
      5'd17: q = (dir == 0) ? {shift_reg[13:0], 17'b00000000000000000} : {17'b00000000000000000, shift_reg[31:17]};
      5'd18: q = (dir == 0) ? {shift_reg[12:0], 18'b000000000000000000} : {18'b000000000000000000, shift_reg[31:18]};
      5'd19: q = (dir == 0) ? {shift_reg[11:0], 19'b0000000000000000000} : {19'b0000000000000000000, shift_reg[31:19]};
      5'd20: q = (dir == 0) ? {shift_reg[10:0], 20'b00000000000000000000} : {20'b00000000000000000000, shift_reg[31:20]};
      5'd21: q = (dir == 0) ? {shift_reg[9:0], 21'b000000000000000000000} : {21'b000000000000000000000, shift_reg[31:21]};
      5'd22: q = (dir == 0) ? {shift_reg[8:0], 22'b0000000000000000000000} : {22'b0000000000000000000000, shift_reg[31:22]};
      5'd23: q = (dir == 0) ? {shift_reg[7:0], 23'b00000000000000000000000} : {23'b00000000000000000000000, shift_reg[31:23]};
      5'd24: q = (dir == 0) ? {shift_reg[6:0], 24'b000000000000000000000000} : {24'b000000000000000000000000, shift_reg[31:24]};
      5'd25: q = (dir == 0) ? {shift_reg[5:0], 25'b0000000000000000000000000} : {25'b0000000000000000000000000, shift_reg[31:25]};
      5'd26: q = (dir == 0) ? {shift_reg[4:0], 26'b00000000000000000000000000} : {26'b00000000000000000000000000, shift_reg[31:26]};
      5'd27: q = (dir == 0) ? {shift_reg[3:0], 27'b000000000000000000000000000} : {27'b000000000000000000000000000, shift_reg[31:27]};
      5'd28: q = (dir == 0) ? {shift_reg[2:0], 28'b0000000000000000000000000000} : {28'b0000000000000000000000000000, shift_reg[31:28]};
      5'd29: q = (dir == 0) ? {shift_reg[1:0], 29'b00000000000000000000000000000} : {29'b00000000000000000000000000000, shift_reg[31:29]};
      5'd30: q = (dir == 0) ? {shift_reg[0], 30'b000000000000000000000000000000} : {30'b000000000000000000000000000000, shift_reg[31:30]};
      5'd31: q = (dir == 0) ? {1'b0, 31'b0000000000000000000000000000000} : {31'b0000000000000000000000000000000, shift_reg[31]};
      default: q = shift_reg; // Fallback
    endcase
  end

endmodule