module top_module(
  input [3:0] d_val,
  input clk,
  input reset,
  output reg v_out
);parameter r_total = 10000; // total resistance of the potentiometer
parameter r_step = 2500; // resistance step value

reg [3:0] r_val; // resistance value

always @(*) begin
  case (d_val)
    4'b0000: r_val = 4'b0000;
    4'b0001: r_val = 4'b0001;
    4'b0010: r_val = 4'b0011;
    4'b0011: r_val = 4'b0111;
    4'b0100: r_val = 4'b1111;
    4'b0101: r_val = 4'b1110;
    4'b0110: r_val = 4'b1100;
    4'b0111: r_val = 4'b1000;
    4'b1000: r_val = 4'b0000;
    4'b1001: r_val = 4'b0001;
    4'b1010: r_val = 4'b0010;
    4'b1011: r_val = 4'b0100;
    4'b1100: r_val = 4'b1000;
    4'b1101: r_val = 4'b1001;
    4'b1110: r_val = 4'b1011;
    4'b1111: r_val = 4'b1111;
  endcase
end

always @(posedge clk) begin
  v_out <= (r_val * r_step) / r_total;
end

always @(posedge reset) begin
  v_out <= 0;
end

endmodule