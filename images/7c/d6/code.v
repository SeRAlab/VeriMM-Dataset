module top_module(
  input [7:0] data,
  input [1:0] ctrl,
  output reg [15:0] display
);parameter width = 80;
parameter height = 25;

reg [7:0] display_data;
reg [1:0] display_ctrl;

always @(data or ctrl) begin
  display_data <= data;
  display_ctrl <= ctrl;
end

always @(display_data or display_ctrl) begin
  case (display_ctrl)
    2'b00: display <= {8'b0, display_data}; // Display data at the beginning of the line
    2'b01: display <= {display_data, 8'b0}; // Display data at the end of the line
    2'b10: display <= {4'b0, display_data, 4'b0}; // Display data at the center of the line
    2'b11: display <= {8'b0, 8'b0}; // Clear the display
    default: display <= {8'b0, 8'b0}; // Clear the display
  endcase
end

endmodule