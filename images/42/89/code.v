module top_module(input wire [3:0] in,
                      input wire [1:0] sel,
                      input wire ena,
                      output reg out);// Change wire to reg

//-- The most significant bit is used as output
wire [3:0] selected_input;

// Use a proper way to select the input based on sel
assign selected_input = in; // Use the entire 'in' input for selection

always @(posedge ena) begin
  if (ena) begin
    out <= selected_input[sel]; // Access selected input using sel
  end else begin
    out <= 1'b0;
  end
end

endmodule