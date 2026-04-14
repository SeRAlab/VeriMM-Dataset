module synchronous_down_counter(
   input                clk,
   input                rst,
   input                load,
   input                en,
   input      [3:0]     D,

   output reg [3:0]     Q
);
    always @(posedge clk) begin
        if (rst) Q <= 4'd0;
        else if (load) Q <= D;
        else if (en) Q <= Q - 1;
    end
endmodule