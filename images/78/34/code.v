module top_module(
  input clk,
  output reg [2:0] traffic_light
);parameter GREEN = 3'b001;
  parameter YELLOW = 3'b010;
  parameter RED = 3'b100;
  
  reg [3:0] state;
  
  always @(posedge clk) begin
    case(state)
      GREEN: begin
        traffic_light <= GREEN;
        if (count == 10) 
          state <= YELLOW;
        else
          count <= count + 1;
      end
      YELLOW: begin
        traffic_light <= YELLOW;
        if (count == 2) 
          state <= RED;
        else
          count <= count + 1;
      end
      RED: begin
        traffic_light <= RED;
        if (count == 10) 
          state <= GREEN;
        else
          count <= count + 1;
      end
      default: state <= GREEN;
    endcase
  end
  
  reg [3:0] count;
  
endmodule