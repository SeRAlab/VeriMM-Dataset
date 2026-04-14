module top_module(
  input clk,
  input reset,
  input pedestrian_button,
  output reg red,
  output reg yellow,
  output reg green
);reg [5:0] counter;

always @(posedge clk) begin
  if (reset) begin
    counter <= 0;
    red <= 1;
    yellow <= 0;
    green <= 0;
  end else begin
    case (counter)
      0: begin
        green <= 1;
        yellow <= 0;
        red <= 0;
        if (pedestrian_button) begin
          counter <= 31;
        end else begin
          counter <= 19;
        end
      end
      20: begin
        green <= 0;
        yellow <= 1;
        red <= 0;
        counter <= 4;
      end
      25: begin
        green <= 0;
        yellow <= 0;
        red <= 1;
        counter <= 29;
      end
      30: begin
        green <= 0;
        yellow <= 1;
        red <= 0;
        counter <= 34;
      end
      default: begin
        green <= 0;
        yellow <= 0;
        red <= 1;
        counter <= counter - 1;
      end
    endcase
  end
end

endmodule