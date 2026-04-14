module Binary_counter(
   input                clk,
   input                rst_n,
   input                en,

   output reg [1:0]     Q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) Q <= 2'b00;
        else if (en) Q <= Q + 1;
    end
endmodule