module top_module(
  input CLK, EN, TE, RESET,
  output reg ENCLK
);// Define the states of the input sequence
  localparam IDLE = 2'b00;
  localparam CLK_HIGH = 2'b01;
  localparam EN_HIGH = 2'b10;
  localparam TE_HIGH = 2'b11;

  // Define the state machine
  reg [1:0] state = IDLE;
  always @(posedge CLK, posedge RESET) begin
    if (RESET) begin
      state <= IDLE;
    end else begin
      case (state)
        IDLE: begin
          if (EN && TE) begin
            state <= CLK_HIGH;
          end
        end
        CLK_HIGH: begin
          if (!EN || !TE) begin
            state <= IDLE;
          end else if (CLK) begin
            state <= EN_HIGH;
          end
        end
        EN_HIGH: begin
          if (!EN || !TE) begin
            state <= IDLE;
          end else if (!CLK) begin
            state <= TE_HIGH;
          end
        end
        TE_HIGH: begin
          if (!EN || !TE) begin
            state <= IDLE;
          end else begin
            state <= IDLE;
            ENCLK <= 1'b1;
          end
        end
      endcase
    end
  end

  // Reset the output pulse when any input changes
  always @(posedge CLK) begin
    if (ENCLK && ((EN != 1'b1) || (TE != 1'b1) || (CLK != 1'b1))) begin
      ENCLK <= 1'b0;
    end
  end

endmodule