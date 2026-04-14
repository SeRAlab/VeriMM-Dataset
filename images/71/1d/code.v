module top_module(
  input clk,
  input data,
  output reg match
);reg [2:0] state;

always @(posedge clk) begin
  case(state)
    3'b000: if(data) state <= 3'b001;
            else state <= 3'b000;
    3'b001: if(data) state <= 3'b010;
            else state <= 3'b000;
    3'b010: if(data) begin
              state <= 3'b011;
              match <= 1;
            end
            else state <= 3'b000;
    3'b011: begin
              state <= 3'b000;
              match <= 0;
            end
  endcase
end

endmodule