module soc_design_SystemID (
  input [31:0] address,
  input clock,
  input reset_n,
  output reg [31:0] readdata
);

  always @(posedge clock) begin
    if (!reset_n) begin
      readdata <= 32'h00000000;
    end else begin
      case (address)
        32'h0: readdata <= 32'hDEADBEEF;
        32'h4: readdata <= 32'hCAFEBABE;
        default: readdata <= 32'h00000000;
      endcase
    end
  end

endmodule