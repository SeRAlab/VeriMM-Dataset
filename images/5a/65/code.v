module top_module(
  input clk,                // Added clk input
  input [7:0] data,
  output reg [31:0] checksum
);// No parameters needed

// Two 16-bit registers, initialized to 1
reg [15:0] s1 = 16'h0001;
reg [15:0] s2 = 16'h0001;

// Operations for each data byte
always @ (posedge clk) begin
  s1 <= (s1 + data) % 65521;
  s2 <= (s2 + s1) % 65521;
end

// Compute Adler checksum after all bytes have been processed
always @* begin
  checksum = (s2 << 16) + s1; // Update checksum on any change
end

endmodule