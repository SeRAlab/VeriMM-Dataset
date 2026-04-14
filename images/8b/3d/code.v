module top_module(
   input signed [7:0] a,
   input signed [7:0] b,
   output reg signed [15:0] result,
   output reg overflow
);reg signed [15:0] temp;
   reg [7:0] count;
   reg [1:0] state;

   always @(*) begin
      case(state)
         2'b00: begin
            temp = 0;
            count = 0;
            state = 2'b01;
         end
         2'b01: begin
            temp = temp + (a << count);
            count = count + 1;
            if(count == 8) begin
               count = 0;
               state = 2'b10;
            end
         end
         2'b10: begin
            temp = temp + (b << count);
            count = count + 1;
            if(count == 8) begin
               count = 0;
               state = 2'b11;
            end
         end
         2'b11: begin
            result = temp;
            if(result > 32767 || result < -32768) begin
               overflow = 1;
            end else begin
               overflow = 0;
            end
            state = 2'b00;
         end
      endcase
   end

endmodule