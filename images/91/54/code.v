module top_module(
  input clk,
  output rst);reg por_done; 
  reg [3:0] count; 

  always @(posedge clk) begin
    if (!por_done)
      if (count == 4'd15) begin
        por_done <= 1;
      end else begin
        count <= count + 1'd1;
      end
  end

  assign rst = !por_done;

endmodule