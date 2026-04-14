module top_module(
  input         clock,
  input         reset,
  input  [31:0] io_in,
  output [31:0] io_out
);reg [31:0] sr_in; // Change wire to reg for proper usage in always block
  wire [31:0] sr_out;
  wire  sr_flow;
  wire  sr_reset;
  wire  sr_clock;

  // Define a simple shift register in lieu of RetimeShiftRegister
  reg [31:0] shift_reg;
  
  always @(posedge clock or posedge reset) begin
    if (reset) begin
      shift_reg <= 32'b0; // Clear the register on reset
    end else begin
      if (sr_flow) begin
        shift_reg <= sr_in; // Update the shift register with sr_in
      end
    end
  end
  
  assign sr_out = shift_reg; // Connect the shift register output
  always @(posedge clock) begin
    if (io_in >= 0) begin
      sr_in <= io_in << 1;
    end else begin
      sr_in <= io_in >> 1;
    end
  end
  
  assign io_out = sr_out;
  assign sr_flow = 1'b1; // Update for proper bit size
  assign sr_reset = reset;
  assign sr_clock = clock;

endmodule