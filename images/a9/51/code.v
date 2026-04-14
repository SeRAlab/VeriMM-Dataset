module top_module(
  input clk,
  input reset,
  input coin,
  input product,
  output reg dispense,
  output reg ready,
  output reg enough_coins,
  output reg out_of_stock
);// Define the states
  parameter Idle = 2'b00;
  parameter Ready = 2'b01;
  parameter Dispense = 2'b10;
  
  // Define the state register and initialize to Idle
  reg [1:0] state = Idle;
  
  // Define the combinational logic block to determine the next state
  always @ (posedge clk) begin
    if (reset) begin
      state <= Idle;
    end else begin
      case (state)
        Idle: begin
          if (product) begin
            state <= Ready;
          end else begin
            state <= Idle;
          end
        end
        Ready: begin
          if (coin) begin
            state <= Dispense;
          end else begin
            state <= Ready;
          end
        end
        Dispense: begin
          if (product && !out_of_stock) begin
            state <= Idle;
          end else begin
            state <= Idle;
          end
        end
      endcase
    end
  end
  
  // Define the output signals based on the current state
  always @ (state) begin
    case (state)
      Idle: begin
        dispense <= 0;
        ready <= 1;
        enough_coins <= 0;
        out_of_stock <= 0;
      end
      Ready: begin
        dispense <= 0;
        ready <= 1;
        enough_coins <= 0;
        out_of_stock <= 0;
      end
      Dispense: begin
        dispense <= 1;
        ready <= 0;
        enough_coins <= 1;
        if (out_of_stock) begin
          out_of_stock <= 1;
        end else begin
          out_of_stock <= 0;
        end
      end
    endcase
  end
  
endmodule