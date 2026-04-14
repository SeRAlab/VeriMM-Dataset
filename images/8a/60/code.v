module up_down_counter 
#(
parameter WIDTH = 4
)
(
  input               clk,
  input               rst,
  input               en,
  input               up_down,
  output reg [WIDTH-1:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= {WIDTH{1'b0}};
    end else if (en) begin
        if (up_down) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end
end

endmodule