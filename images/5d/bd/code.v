module top_module(
    input select0,
    input select1,
    input z,
    input v,
    input n,
    output reg [15:0] result
  );localparam WIDTH = 5'h10;
  
  
  always @* begin
    if (select1) begin
      if (select0) begin
        result[0+0-:1] = z | (n ^ v);
      end else begin
        result[0+0-:1] = n ^ v;
      end
    end else begin
      if (select0) begin
        result[0+0-:1] = z;
      end else begin
        result[0+0-:1] = 1'h0;
      end
    end
  end
endmodule