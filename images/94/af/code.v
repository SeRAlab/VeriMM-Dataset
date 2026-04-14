module top_module(
  input clk,
  input reset,
  input [7:0] data_in,
  input start,
  output reg tx,
  output reg done
);localparam IDLE = 2'b00;
  localparam START = 2'b01;
  localparam TRANSMIT = 2'b10;
  reg [1:0] state = IDLE;
  reg [3:0] bit_count = 4'd0;
  reg [7:0] data_reg;
  reg start_reg;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      bit_count <= 4'd0;
      data_reg <= 8'd0;
      tx <= 1'b1;
      done <= 1'b0;
      start_reg <= 1'b0;
    end else begin
      case (state)
        IDLE: begin
          if (start) begin
            start_reg <= 1'b1;
            state <= START;
          end
        end
        START: begin
          if (!start) begin
            state <= IDLE;
          end else if (bit_count == 4'd0) begin
            tx <= 1'b0;
            data_reg <= data_in;
            bit_count <= 4'd1;
          end else begin
            bit_count <= bit_count + 1;
            state <= TRANSMIT;
          end
        end
        TRANSMIT: begin
          if (bit_count == 4'd9) begin
            tx <= 1'b1;
            bit_count <= 4'd0;
            state <= START;
            if (data_reg == 8'hFF) begin
              done <= 1'b1;
            end
          end else begin
            tx <= data_reg[0];
            data_reg <= {data_reg[6:0], 1'b0};
            bit_count <= bit_count + 1;
          end
        end
      endcase
    end
  end

  always @(posedge clk) begin
    if (reset) begin
      start_reg <= 1'b0;
    end else begin
      if (start) begin
        start_reg <= 1'b1;
      end else if (done) begin
        start_reg <= 1'b0;
      end
    end
  end

  assign start = start_reg;

endmodule