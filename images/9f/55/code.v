module top_module(
  input clk,
  input reset,
  input a,
  input b,
  input c,
  output reg out1,
  output reg out2,
  output reg out3
);parameter S0 = 5'b00001,
            S1 = 5'b00010,
            S2 = 5'b00100,
            S3 = 5'b01000,
            S4 = 5'b10000;

  reg [4:0] state, next_state;

  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
    end else begin
      state <= next_state;
    end
  end

  always @* begin
    case (state)
      S0: begin
        out1 = 1'b0;
        out2 = 1'b0;
        out3 = 1'b0;
        if (a) begin
          next_state = S1;
        end else begin
          next_state = S0;
        end
      end
      S1: begin
        out1 = 1'b1;
        out2 = 1'b0;
        out3 = 1'b0;
        if (!a && b) begin
          next_state = S2;
        end else begin
          next_state = S1;
        end
      end
      S2: begin
        out1 = 1'b0;
        out2 = 1'b1;
        out3 = 1'b0;
        if (!b && c) begin
          next_state = S3;
        end else begin
          next_state = S2;
        end
      end
      S3: begin
        out1 = 1'b0;
        out2 = 1'b0;
        out3 = 1'b1;
        if (!c) begin
          next_state = S4;
        end else begin
          next_state = S3;
        end
      end
      S4: begin
        out1 = 1'b1;
        out2 = 1'b1;
        out3 = 1'b1;
        if (reset) begin
          next_state = S0;
        end else begin
          next_state = S4;
        end
      end
    endcase
  end

endmodule