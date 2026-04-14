module top_module(
  input clock,
  input resetn,
  input clear,
  input enable,
  input [WIDTH-1:0] D_in,  // Changed the name of input D to D_in
  output [WIDTH-1:0] Q
);parameter WIDTH = 32;
  parameter STAGES = 1;

  // Removed redundant wire declaration for D
  reg [WIDTH-1:0] stages [STAGES-1:0];

  generate
  if (STAGES == 0) begin
    assign Q = D_in;  // Update to use D_in
  end
  else begin
    genvar i;
    for (i = 0; i < STAGES; i = i + 1) begin : stages_loop
      always @(posedge clock or negedge resetn) begin
        if (!resetn) begin
          stages[i] <= {(WIDTH){1'b0}};
        end
        else if (clear) begin
          stages[i] <= {(WIDTH){1'b0}};
        end
        else if (enable) begin
          if (i == 0) begin
            stages[i] <= D_in;  // Update to use D_in
          end
          else begin
            stages[i] <= stages[i-1];
          end
        end
      end
    end
    assign Q = stages[STAGES-1];
  end
  endgenerate
endmodule