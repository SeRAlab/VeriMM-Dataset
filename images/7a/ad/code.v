module top_module(
  inclk,
  ena,
  devpor,
  devclrn,
  enaout,
  outclk
);// INPUT PORTS
input inclk;
input ena;
input devpor;
input devclrn;

// OUTPUT PORTS
output enaout;
output outclk;

// REGISTERS
reg [1:0] ena_reg; // Register to hold enable signal
reg [1:0] reset_reg; // Register to hold reset state
reg outclk_reg; // Register to hold outclk signal

// WIRE FOR OUTPUT
wire enaout_wire; // Intermediate wire for enaout

// COMBINATIONAL LOGIC
assign enaout_wire = (ena_reg[1] & !reset_reg[1]) | (ena_reg[0] & !reset_reg[0]); // Generate enaout signal
assign outclk = inclk & enaout_wire; // Generate outclk signal

// REGISTERED LOGIC
always @(posedge inclk) begin
  ena_reg <= {ena_reg[0], ena}; // Shift enable signal into register
  reset_reg <= {reset_reg[0], devpor | devclrn}; // Shift reset state into register
  outclk_reg <= outclk; // Shift outclk signal into register
end

// OUTPUT REGISTERS
assign enaout = enaout_wire;

endmodule