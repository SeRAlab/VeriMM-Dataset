module top_module(clk, reset_n, test_expr, xzcheck_enable, odd_parity, x_detected, z_detected);parameter width = 1;
       input clk, reset_n;
       input [width-1:0] test_expr;
       input xzcheck_enable;
       output odd_parity, x_detected, z_detected;

       reg [width-1:0] odd_parity_reg;
       reg [width-1:0] x_detected_reg;
       reg [width-1:0] z_detected_reg;

       always @(posedge clk) begin
           if (!reset_n) begin
               odd_parity_reg <= 1'b0;
               x_detected_reg <= 1'b0;
               z_detected_reg <= 1'b0;
           end else begin
               odd_parity_reg <= ^test_expr;
               if (xzcheck_enable) begin
                   x_detected_reg <= |test_expr === 1'bx;
                   z_detected_reg <= |test_expr === 1'bz;
               end
           end
       end

       assign odd_parity = odd_parity_reg;
       assign x_detected = x_detected_reg;
       assign z_detected = z_detected_reg;
endmodule