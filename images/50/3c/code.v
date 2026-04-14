module top_module(
   input  wire        clk,
   input  wire        rst,
   input  wire [1:0]  op,
   input  wire [7:0]  num1,
   input  wire [7:0]  num2,
   output reg  [7:0]  result,
   output reg         overflow,
   output reg         zero
);reg [15:0] temp;

   always @ (posedge clk or posedge rst) begin
      if (rst) begin
         result   <= 8'b0;
         overflow <= 1'b0;
         zero     <= 1'b0;
      end else begin
         case (op)
            2'b00: begin // addition
               temp <= {8'b0, num1} + {8'b0, num2};
            end
            2'b01: begin // subtraction
               temp <= {8'b0, num1} - {8'b0, num2};
            end
            2'b10: begin // multiplication
               temp <= {8'b0, num1} * {8'b0, num2};
            end
            2'b11: begin // division
               temp <= {16'b0, num1} / {16'b0, num2};
            end
         endcase

         if (temp > 8'hFF || temp < 0) begin
            overflow <= 1'b1;
         end else begin
            overflow <= 1'b0;
         end

         if (temp == 0) begin
            zero <= 1'b1;
         end else begin
            zero <= 1'b0;
         end

         result <= temp[7:0];
      end
   end
endmodule