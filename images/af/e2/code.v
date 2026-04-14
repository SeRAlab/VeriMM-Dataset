module bidirectional_shift_register (
  input clk,
  input en,
  input rst,
  input dir,
  input [5:0] parallel_data,
  output reg [5:0] q);

always @(posedge clk) begin
    if (rst)
        q <= 6'b000000;
    else if (en)
        if (dir)
            q <= {q[4:0], 1'b0};
        else
            q <= {1'b0, q[5:1]};
end
endmodule