module top_module(
  input in,
  output out
);parameter n = 4; // number of bits in the input stream

reg [1:0] state;
reg out_reg;

always @(posedge in) begin
  case(state)
    2'b00: if(in) state <= 2'b01; else state <= 2'b00;
    2'b01: if(in) state <= 2'b10; else state <= 2'b00;
    2'b10: if(in) begin
             state <= 2'b11;
             out_reg <= 1;
           end
           else begin
             state <= 2'b00;
             out_reg <= 0;
           end
    2'b11: if(in) state <= 2'b10; else state <= 2'b01;
  endcase
end

assign out = out_reg;

endmodule