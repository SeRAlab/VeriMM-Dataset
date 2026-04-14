module top_module(
  output reg [3:0] DATAOUT,
  input clock,
  input reset,
  input [1:0] MODE,
  input [3:0] DATAIN
);reg [3:0] shift_reg;

  always @(posedge clock) begin
    if (reset) begin
      shift_reg <= 4'b0000;
    end else begin
      case (MODE)
        2'b00: begin // Serial Right Shift
          shift_reg <= {shift_reg[2:0], DATAIN[3]};
        end
        2'b01: begin // Serial Left Shift
          shift_reg <= {DATAIN[0], shift_reg[3:1]};
        end
        2'b10: begin // Parallel Load
          shift_reg <= DATAIN;
        end
        default: begin // Invalid mode
          shift_reg <= shift_reg;
        end
      endcase
    end
  end

  assign DATAOUT = shift_reg;

endmodule