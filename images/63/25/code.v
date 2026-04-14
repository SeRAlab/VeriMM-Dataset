module top_module(
  input  wire        clk,
  input  wire        rst,
  input  wire [7:0]  A,
  input  wire [7:0]  B,
  input  wire [1:0]  op_sel, // Added op_sel input
  output reg  [7:0]  sum,
  output reg  [7:0]  diff,
  output reg  [7:0]  prod,
  output reg  [7:0]  quot
);reg [7:0] result;
  reg [7:0] prod_temp;
  reg [7:0] quot_temp;
  
  always @(posedge clk) begin
    if (rst) begin
      sum <= 8'h00;
      diff <= 8'h00;
      prod <= 8'h00;
      quot <= 8'h00;
    end
    else begin
      case(op_sel) // Use op_sel input directly
        2'b00: begin // addition
          result <= A + B;
          sum <= result;
        end
        2'b01: begin // subtraction
          result <= A - B;
          diff <= result;
        end
        2'b10: begin // multiplication
          prod_temp <= A * B;
          if (prod_temp > 8'hFF) begin
            prod <= 8'hFF;
          end
          else begin
            prod <= prod_temp;
          end
        end
        2'b11: begin // division
          if (B == 8'h00) begin
            quot <= 8'h00;
            prod <= 8'hFF;
          end
          else begin
            quot_temp <= A / B;
            quot <= quot_temp;
          end
        end
      endcase
    end
  end

endmodule