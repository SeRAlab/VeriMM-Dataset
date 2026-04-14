module top_module(
  input clk,         // Clock input
  input rst_n,       // Asynchronous reset input
  input [7:0] in,    // 8-bit input for the multiplexer
  output reg [7:0] out   // 8-bit output from the multiplexer
);reg [3:0] johnson;  // 4-bit Johnson counter
  reg select;         // Select input for the multiplexer

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      johnson <= 4'b0000;
      select <= 1'b0;
    end else begin
      // Shift the Johnson counter
      johnson <= {johnson[2:0], johnson[3] ^ johnson[0]};

      // Generate the select signal
      if (johnson == 4'b0000 || johnson == 4'b1111) begin
        select <= 1'b0;
      end else begin
        select <= 1'b1;
      end
    end
  end

  // Multiplexer
  always @(*) begin
    if (select) begin
      out = {4'b0000, johnson}; // Extend johnson to 8 bits
    end else begin
      out = in;
    end
  end

endmodule