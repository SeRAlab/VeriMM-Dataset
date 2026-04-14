module binary_counter(clk, rst, load, data, count);

  input clk, rst, load;
  input [3:0] data;
  output [3:0] count;

  reg [3:0] count;

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      count <= 4'b0;
    end else if (load) begin
      count <= data;
    end else begin
      count <= count + 4'b1;
    end
  end

endmodule