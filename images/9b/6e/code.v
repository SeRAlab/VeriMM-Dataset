module top_module(
  input clk,            
  input rst,            
  input RX,             
  output reg busy,      
  output reg [7:0] data 
);reg RX_d;
reg [9:0] datafill;
reg [3:0] index;
reg [3:0] sampler;

always @(posedge clk) begin
  RX_d <= RX;
  if (rst) begin
    busy <= 1'b0;
    datafill <= 10'b0;
    index <= 4'b0;
    sampler <= 4'b0;
  end else begin
    if (~busy & ~RX_d) begin
      busy <= 1'b1;
      sampler <= 4'b0;
      index <= 4'b0;
    end
    if (busy) begin
      sampler <= sampler + 1'b1;
      if (sampler == 4'd7) begin
        if (RX_d & ~|index) 
          busy <= 1'b0;
        else begin
          index <= index + 1'b1;
          datafill[index] <= RX_d;
          if (index == 9) begin
            data <= datafill[8:1];
            index <= 4'b0;
            busy <= 1'b0;
          end
        end
      end
    end
  end
end

endmodule