module top_module(
  input CLK,
  input EN,
  input TE,
  output reg ENCLK  // Change 'output' to 'output reg'
);reg [1:0] state;
  parameter IDLE = 2'b00, TRIGGERED = 2'b01, ENABLED = 2'b10;

  always @(posedge CLK) begin
    case (state)
      IDLE: begin
        ENCLK <= 1'b0;
        if (EN) begin
          state <= TRIGGERED;
        end
      end
      TRIGGERED: begin
        ENCLK <= 1'b1;
        if (TE) begin
          state <= ENABLED;
        end
      end
      ENABLED: begin
        ENCLK <= 1'b0;
        state <= IDLE;
      end
    endcase
  end

endmodule