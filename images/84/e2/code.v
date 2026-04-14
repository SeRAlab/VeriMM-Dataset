module top_module(input clk, input serial_in, output reg serial_out);reg [2:0] shift_reg;
  reg [1:0] mux_sel; // Changed to reg type since mux_sel will be assigned in an always block
  wire d1, d2, d3;
  
  assign d1 = serial_in;
  assign d2 = shift_reg[0];
  assign d3 = shift_reg[1];
  // Removed direct assignment to serial_out in anyway block
  
  always @(posedge clk) begin
    shift_reg <= {d3, d2, d1};
    serial_out <= shift_reg[2]; // Assign to serial_out inside the clocked always block
  end
  
  always @* begin
    mux_sel = 2'b10; // Mux selection assigned in the combinatorial block
    case (mux_sel)
      2'b00: serial_out = d1;
      2'b01: serial_out = d2;
      2'b10: serial_out = d3;
      default: serial_out = 1'b0; // Ensures a defined output
    endcase
  end
endmodule