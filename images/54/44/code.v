module top_module(
  input clk,
  input reset,
  output reg [2:0] count
);reg [2:0] next_count;
  
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      next_count <= 3'b000;
    end else begin
      case (count)
        3'b000: next_count <= 3'b001;
        3'b001: next_count <= 3'b010;
        3'b010: next_count <= 3'b011;
        3'b011: next_count <= 3'b100;
        3'b100: next_count <= 3'b101;
        3'b101: next_count <= 3'b110;
        3'b110: next_count <= 3'b111;
        3'b111: next_count <= 3'b000;
      endcase
    end
  end
  
  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      count <= 3'b000;
    end else begin
      count <= next_count;
    end
  end
  
endmodule