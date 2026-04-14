module top_module(
  input clk,
  input reset,
  input data,
  output reg match
);parameter SEARCHING = 2'b00;
  parameter DETECTING = 2'b01;
  
  reg [1:0] state;
  reg [3:0] shift_reg;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= SEARCHING;
      shift_reg <= 4'b0;
      match <= 0;
    end else begin
      case (state)
        SEARCHING: begin
          if (data == 1) begin
            state <= DETECTING;
            shift_reg <= {data, shift_reg[3:1]};
          end
        end
        DETECTING: begin
          shift_reg <= {data, shift_reg[3:1]};
          if (shift_reg == 4'b1010) begin
            match <= 1;
            state <= SEARCHING;
          end else if (shift_reg[0] == 0) begin
            state <= SEARCHING;
          end
        end
      endcase
    end
  end

endmodule