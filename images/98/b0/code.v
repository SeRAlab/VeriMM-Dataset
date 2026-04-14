module top_module(
  input sys_clk,
  input [1:0] test_intlk_status,
  input [31:0] wb_reg,
  output reg err,
  output reg err_intlk,
  output reg err_wb
);// Interlock status from Wishbone register
  reg [1:0] intlk_wb;

  // Flag to indicate if test is in progress
  reg test_in_progress;

  always @(posedge sys_clk) begin
    if (test_in_progress) begin
      // Compare interlock status from test module and Wishbone register
      if (test_intlk_status != intlk_wb) begin
        $display("Interlock status mismatch: test module = %d, Wishbone register = %d", test_intlk_status, intlk_wb);
        err = 1;
        if (test_intlk_status != 0) begin
          err_intlk = 1;
        end
        if (intlk_wb != 0) begin
          err_wb = 1;
        end
      end else begin
        $display("Interlock status match: test module = %d, Wishbone register = %d", test_intlk_status, intlk_wb);
      end

      // End of test
      test_in_progress = 0;
    end else begin
      // Clear interlock flags
      err = 0;
      err_intlk = 0;
      err_wb = 0;

      // Read interlock status from Wishbone register
      intlk_wb = (wb_reg & 2'b11);

      // Wait for two clock cycles
      #(2);

      // Start test
      test_in_progress = 1;
    end
  end

endmodule