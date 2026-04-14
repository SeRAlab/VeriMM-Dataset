module top_module(
   input clk,
   input reset,
   input load,
   input [1:0] ena,
   input [49:0] data,
   input a,
   input b,
   input c,
   output reg [49:0] q,
   output out
);reg [49:0] shift_reg;
reg [1:0] state;

assign out = ~(a & b & c);

always @ (posedge clk) begin
   if (reset) begin
      shift_reg <= 50'b0;
      state <= 2'b00;
   end else begin
      if (load) begin
         shift_reg <= data;
         state <= 2'b00;
      end else begin
         case (state)
            2'b00: begin // idle
               shift_reg <= shift_reg;
               if (ena == 2'b01) begin
                  state <= 2'b01; // rotate left
               end else if (ena == 2'b10) begin
                  state <= 2'b10; // rotate right
               end
            end
            2'b01: begin // rotate left
               shift_reg <= {shift_reg[48:0], shift_reg[49]};
               if (ena == 2'b00) begin
                  state <= 2'b00; // idle
               end
            end
            2'b10: begin // rotate right
               shift_reg <= {shift_reg[0], shift_reg[49:1]};
               if (ena == 2'b00) begin
                  state <= 2'b00; // idle
               end
            end
         endcase
      end
   end
end

assign q = shift_reg;

endmodule