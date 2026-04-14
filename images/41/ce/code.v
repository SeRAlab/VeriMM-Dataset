module top_module(
    input wire [7:0] in,
    output logic [2:0] out
  );integer i;
  always @* begin
    out = 0; 
    for (i=7; i>=0; i=i-1)
        if (in[i]) out = i;
  end

endmodule