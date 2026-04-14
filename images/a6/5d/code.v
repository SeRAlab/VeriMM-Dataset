module top_module(
  input [ax_width-1:0] ax,
  input [ay_scan_in_width-1:0] ay,
  output reg [result_a_width-1:0] resulta  // Change to reg to hold the result
);parameter ax_width = 9;
parameter signed_max = "true";
parameter ay_scan_in_width = 9;
parameter signed_may = "true";
parameter result_a_width = 18;
parameter operation_mode = "M9x9";

reg signed [ax_width-1:0] signed_ax;
reg signed [ay_scan_in_width-1:0] signed_ay;
reg [result_a_width-1:0] signed_resulta;     // Changed to reg to hold intermediate result of signed operation
wire [2*result_a_width-1:0] intermediate_result;

always @(*) begin
  if (signed_max) begin
    signed_ax = ax;
  end else begin
    signed_ax = {{ax_width-1{1'b0}}, ax};
  end

  if (signed_may) begin
    signed_ay = ay;
  end else begin
    signed_ay = {{ay_scan_in_width-1{1'b0}}, ay};
  end
end

always @(*) begin
  if (operation_mode == "M9x9") begin
    signed_resulta = signed_ax * signed_ay;   // Directly compute signed_resulta
  end else if (operation_mode == "M18x18") begin
    signed_resulta = $signed($signed(signed_ax) * $signed(signed_ay));
  end else begin
    signed_resulta = 0; // Default case to avoid latches
  end
end

always @(*) begin
  reg [result_a_width-1:0] unsigned_resulta; // Declare unsigned_resulta as reg for further assignments

  if (signed_resulta >= 0) begin
    unsigned_resulta = signed_resulta;
  end else begin
    unsigned_resulta = ~signed_resulta + 1;
  end
  
  if (result_a_width < $bits(unsigned_resulta)) begin
    resulta = unsigned_resulta[result_a_width-1:0];
  end else begin
    resulta = {{result_a_width-$bits(unsigned_resulta){1'b0}}, unsigned_resulta};
  end
end

endmodule