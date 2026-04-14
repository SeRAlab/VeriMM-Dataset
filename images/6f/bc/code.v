module top_module(
  input clk,
  input reset,
  input load,
  input control,
  input [3:0] data,         // Added input declaration for data
  output reg [3:0] count,
  output reg max_reached,   // Changed from wire to reg
  output reg min_reached     // Changed from wire to reg
);always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 4'b0;
      max_reached <= 1'b0;
      min_reached <= 1'b0;
    end else if (load) begin
      count <= data;
      max_reached <= (data == 4'b1111);
      min_reached <= (data == 4'b0000);
    end else begin
      if (control) begin
        if (count == 4'b1111) begin
          count <= 4'b0;
          max_reached <= 1'b1;
        end else begin
          count <= count + 1;
          max_reached <= 1'b0;
        end
      end else begin
        if (count == 4'b0000) begin
          count <= 4'b1111;
          min_reached <= 1'b1;
        end else begin
          count <= count - 1;
          min_reached <= 1'b0;
        end
      end
    end
  end

endmodule