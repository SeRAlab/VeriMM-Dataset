module top_module(
  input wire bus_in,
  output reg bus_out
);always @(bus_in) begin
    if(bus_in === 1'b1 || bus_in === 1'b0) begin
      bus_out <= bus_in;
    end
  end
  
endmodule