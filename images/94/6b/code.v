module top_module(
  input  wire           clk,
  input  wire           rst_n,
  input  wire [3:0]     a,
  input  wire [3:0]     b,
  input  wire [1:0]     op,
  output reg  [7:0]     result
);always @(posedge clk, negedge rst_n) begin
    if(!rst_n) begin
      // reset logic
      result <= 0;
    end else begin
      // arithmetic logic
      case(op)
        // addition
        2'b00: begin
          result <= a + b;
        end
        
        // subtraction
        2'b01: begin
          result <= a - b;
        end
        
        // multiplication
        2'b10: begin
          result <= a * b;
        end
        
        // division
        2'b11: begin
          result <= a / b;
        end
      endcase
    end
  end

endmodule