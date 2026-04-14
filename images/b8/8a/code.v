module top_module(
    input            clk,
    input            reset,
    input            enable,
    output reg [3:0] count
  );// --------------------------------------------------------------------
  // Internal wires and registers Declarations
  // --------------------------------------------------------------------
  reg [3:0] next_count;

  // --------------------------------------------------------------------
  // Sequential logic
  // --------------------------------------------------------------------
  always @(posedge clk or posedge reset) begin
    if (reset == 1'b1) begin
      count <= 4'h0;
      next_count <= 4'h0;
    end
    else begin
      if (enable == 1'b1) begin
        next_count <= count + 4'h1;
      end
      else begin
        next_count <= count;
      end
      
      count <= next_count;
    end
  end

endmodule