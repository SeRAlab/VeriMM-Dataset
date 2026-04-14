module piso_shift_register 
#(
parameter WIDTH = 16
)
(
  input                       clk,
  input                       rst,
  input                       load,
  input                       shift,
  input  [WIDTH-1:0]          parallel_in,
  output reg                  serial_out
);

reg [WIDTH-1:0] shift_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        shift_reg <= {WIDTH{1'b0}};
        serial_out <= 1'b0;
    end else if (load) begin
        shift_reg <= parallel_in;
    end else if (shift) begin
        serial_out <= shift_reg[0];
        shift_reg <= shift_reg >> 1;
    end
end

endmodule