module top_module(
  input  clk,
  input  en,
  input  i,
  output reg [6:1] o
);localparam [7:0] dly1 = 1;
wire       [7:0] dly2 = 2;
reg        [7:0] dly3 = 3;

// Use 'assign' instead of tranif1 for output assignment
always @(en or i) begin
  if (en) begin
    o[1] = i; // using input directly
    o[2] = i; // using input directly
    o[3] = i; // using input directly
    o[4] = i; // using input directly
    o[5] = i; // using input directly
    o[6] = i; // using input directly
  end
end

always @(posedge clk) begin
  if (en)
    o <= {o[5:1], 1'b0}; // Shift behavior for the delay
end

endmodule