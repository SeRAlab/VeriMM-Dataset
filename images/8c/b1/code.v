module top_module(
  input clk,
  input reset,
  input data,
  output reg [3:0] count
);reg [1:0] state;
reg [3:0] temp_count;

always @(posedge clk) begin
  if (reset) begin
    state <= 2'b00;
    count <= 4'd0;
    temp_count <= 4'd0;
  end
  else begin
    case (state)
      2'b00: begin
        if (data) begin
          state <= 2'b01;
          temp_count <= 4'd1;
        end
        else begin
          state <= 2'b00;
          temp_count <= 4'd0;
        end
      end
      2'b01: begin
        if (data) begin
          state <= 2'b01;
          temp_count <= temp_count + 1;
        end
        else begin
          state <= 2'b10;
          count <= temp_count;
          temp_count <= 4'd0;
        end
      end
      2'b10: begin
        if (data) begin
          state <= 2'b01;
          temp_count <= 4'd1;
        end
        else begin
          state <= 2'b00;
          temp_count <= 4'd0;
        end
      end
    endcase
  end
end

endmodule